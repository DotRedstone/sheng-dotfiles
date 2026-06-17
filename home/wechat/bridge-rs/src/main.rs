use std::collections::{HashMap, HashSet};
use std::env;
use std::ffi::CString;
use std::fs::{self, File};
use std::io::{self, Read, Write};
use std::os::raw::{c_char, c_int};
use std::os::unix::fs::{FileExt, PermissionsExt};
use std::os::unix::io::FromRawFd;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::thread;
use std::time::{Duration, Instant, SystemTime};

type AnyError = Box<dyn std::error::Error>;
type Result<T> = std::result::Result<T, AnyError>;

const MESSAGE_TYPE_MASK: i64 = 0xffff_ffff;
const TEXT_TYPE: i64 = 1;
const SUPPORTED_MESSAGE_SQL: &str = "(((local_type & 4294967295) = 1 AND message_content IS NOT NULL AND length(message_content) > 0) OR ((local_type & 4294967295) IN (3, 34, 43, 47, 49, 50)) OR ((local_type & 4294967295) = 10000 AND message_content IS NOT NULL AND (message_content LIKE '%通话%' OR message_content LIKE '%红包%' OR message_content LIKE '%转账%')))";

const IN_MODIFY: u32 = 0x0000_0002;
const IN_CLOSE_WRITE: u32 = 0x0000_0008;
const IN_MOVED_TO: u32 = 0x0000_0080;
const IN_CREATE: u32 = 0x0000_0100;
const IN_DELETE: u32 = 0x0000_0200;

unsafe extern "C" {
    fn inotify_init1(flags: c_int) -> c_int;
    fn inotify_add_watch(fd: c_int, pathname: *const c_char, mask: u32) -> c_int;
}

#[derive(Clone, Copy, Debug, Default)]
struct Cursor {
    time: i64,
    id: i64,
}

#[derive(Clone, Debug)]
struct Account {
    dir: PathBuf,
    name: String,
}

#[derive(Clone, Debug)]
struct MessageRow {
    chat: String,
    local_id: i64,
    local_type: i64,
    real_sender_id: i64,
    create_time: i64,
    content: String,
}

struct Bridge {
    home: PathBuf,
    runtime: PathBuf,
    cache_path: PathBuf,
    state_path: PathBuf,
    cache: HashMap<String, String>,
    keys: HashMap<String, String>,
    memory_key_candidates: Vec<String>,
    scanned_memory: bool,
    last_memory_scan: Option<Instant>,
    memory_scan_cooldown: Duration,
}

fn main() {
    let mark_seen = env::args().skip(1).any(|arg| arg == "--mark-seen");

    if let Err(err) = Bridge::new().and_then(|mut bridge| {
        if mark_seen {
            bridge.mark_all_seen()?;
            return Ok(());
        }

        bridge.run()
    }) {
        eprintln!("wechat-notify-bridge: {err}");
        std::process::exit(1);
    }
}

impl Bridge {
    fn new() -> Result<Self> {
        let home = PathBuf::from(env::var("HOME")?);
        let runtime_base = env::var_os("XDG_RUNTIME_DIR")
            .map(PathBuf::from)
            .unwrap_or_else(env::temp_dir);
        let runtime = runtime_base.join("wechat-notify-bridge");
        fs::create_dir_all(&runtime)?;
        fs::set_permissions(&runtime, fs::Permissions::from_mode(0o700))?;

        let cache_path = runtime.join("keys.env");
        let state_path = runtime.join("state.tsv");
        let cache = load_key_cache(&cache_path);

        Ok(Self {
            home,
            runtime,
            cache_path,
            state_path,
            cache,
            keys: HashMap::new(),
            memory_key_candidates: Vec::new(),
            scanned_memory: false,
            last_memory_scan: None,
            memory_scan_cooldown: Duration::from_secs(10),
        })
    }

    fn run(&mut self) -> Result<()> {
        if !self.state_path.exists() {
            let _ = self.mark_all_seen();
        }

        loop {
            if self.account().is_none() {
                thread::sleep(Duration::from_secs(2));
                continue;
            }

            wait_for_message_change(&self.home)?;
            thread::sleep(Duration::from_millis(35));

            if is_wechat_focused() {
                let _ = self.mark_all_seen();
                continue;
            }

            let mut emitted = false;
            let mut retried_empty = false;

            for _ in 0..5 {
                match self.next_message() {
                    Ok(Some(line)) => {
                        emitted = true;
                        notify(&line);
                        thread::sleep(Duration::from_millis(100));
                    }
                    Ok(None) if !emitted && !retried_empty => {
                        retried_empty = true;
                        thread::sleep(Duration::from_millis(80));
                    }
                    Ok(None) => break,
                    Err(err) => {
                        eprintln!("wechat-notify-bridge: {err}");
                        break;
                    }
                }
            }
        }
    }

    fn account(&self) -> Option<Account> {
        newest_account_dir(&self.home).map(|dir| {
            let raw = dir
                .file_name()
                .and_then(|name| name.to_str())
                .unwrap_or_default()
                .to_string();
            let name = raw
                .rsplit_once('_')
                .map(|(prefix, _)| prefix.to_string())
                .unwrap_or(raw);

            Account { dir, name }
        })
    }

    fn mark_all_seen(&mut self) -> Result<()> {
        let account = self
            .account()
            .ok_or_else(|| io::Error::new(io::ErrorKind::NotFound, "no WeChat account db"))?;
        let msg_db = self.copy_db(&account, "db_storage/message/message_0.db", "message_0.db")?;
        let msg_key = self.ensure_key("message", &msg_db)?;
        let names = self.name2id(&msg_db, &msg_key)?;
        let known = known_message_tables(&msg_db, &msg_key, &names)?;
        let mut state = load_state(&self.state_path);

        mark_current_seen(&msg_db, &msg_key, &known, &mut state)?;
        save_state(&self.state_path, &state)?;
        Ok(())
    }

    fn next_message(&mut self) -> Result<Option<String>> {
        let account = self
            .account()
            .ok_or_else(|| io::Error::new(io::ErrorKind::NotFound, "no WeChat account db"))?;
        let msg_db = self.copy_db(&account, "db_storage/message/message_0.db", "message_0.db")?;
        let contact_db = self.copy_db(&account, "db_storage/contact/contact.db", "contact.db")?;
        let msg_key = self.ensure_key("message", &msg_db)?;
        let contact_key = self.ensure_key("contact", &contact_db)?;

        let names = self.name2id(&msg_db, &msg_key)?;
        let id_to_user = id_to_user(&names);
        let own_id = id_to_user
            .iter()
            .find_map(|(id, name)| (name == &account.name).then_some(*id))
            .unwrap_or(-1);
        let known = known_message_tables(&msg_db, &msg_key, &names)?;
        let muted = muted_chatrooms(&contact_db, &contact_key)?;
        let mut state = load_state(&self.state_path);

        let muted_tables: Vec<(String, String)> = known
            .iter()
            .filter(|(chat, _)| muted.contains(chat))
            .cloned()
            .collect();
        if !muted_tables.is_empty() {
            mark_current_seen(&msg_db, &msg_key, &muted_tables, &mut state)?;
            save_state(&self.state_path, &state)?;
        }

        let rows = query_next_message(&msg_db, &msg_key, &known, &muted, &state, own_id)?;
        let Some(row) = rows.into_iter().next() else {
            return Ok(None);
        };

        let session = self
            .copy_db(&account, "db_storage/session/session.db", "session.db")
            .and_then(|db| self.ensure_key("session", &db).map(|key| (db, key)))
            .ok();
        let sender_user = id_to_user.get(&row.real_sender_id).cloned().unwrap_or_default();
        let line = format_message(
            &contact_db,
            &contact_key,
            session.as_ref().map(|(db, _)| db.as_path()),
            session.as_ref().map(|(_, key)| key.as_str()),
            &row.chat,
            &sender_user,
            row.local_type,
            &row.content,
        );

        state.insert(
            row.chat,
            Cursor {
                time: row.create_time,
                id: row.local_id,
            },
        );
        save_state(&self.state_path, &state)?;

        Ok(line)
    }

    fn copy_db(&self, account: &Account, rel: &str, name: &str) -> Result<PathBuf> {
        let src = account.dir.join(rel);
        let dst = self.runtime.join(name);
        fs::copy(&src, &dst)?;
        sync_sqlite_sidecars(&src, &dst)?;
        Ok(dst)
    }

    fn ensure_key(&mut self, label: &str, db: &Path) -> Result<String> {
        if let Some(key) = self.keys.get(label).cloned() {
            if validate_key(db, &key) {
                return Ok(key);
            }
            self.keys.remove(label);
        }

        if let Some(key) = self.cache.get(label).cloned() {
            if validate_key(db, &key) {
                self.keys.insert(label.to_string(), key.clone());
                return Ok(key);
            }
            self.cache.remove(label);
            let _ = save_key_cache(&self.cache_path, &self.cache);
        }

        let mut candidates = Vec::new();
        for key in self.cache.values() {
            if !candidates.contains(key) {
                candidates.push(key.clone());
            }
        }

        let needs_rescan = self
            .last_memory_scan
            .map_or(true, |last| last.elapsed() >= self.memory_scan_cooldown);

        if !self.scanned_memory || needs_rescan {
            let found = memory_candidates();
            if !found.is_empty() || !self.scanned_memory {
                println!(
                    "wechat-notify-bridge: found {} memory key candidates",
                    found.len()
                );
            }
            for key in found {
                if !self.memory_key_candidates.contains(&key) {
                    self.memory_key_candidates.push(key);
                }
            }
            self.scanned_memory = true;
            self.last_memory_scan = Some(Instant::now());
        }

        for key in &self.memory_key_candidates {
            if !candidates.contains(key) {
                candidates.push(key.clone());
            }
        }

        for key in &candidates {
            if validate_key(db, key) {
                println!("wechat-notify-bridge: validated key for {}", label);
                self.cache.insert(label.to_string(), key.clone());
                self.keys.insert(label.to_string(), key.clone());
                save_key_cache(&self.cache_path, &self.cache)?;
                return Ok(key.clone());
            }
        }

        Err(io::Error::new(
            io::ErrorKind::NotFound,
            format!("no key for {} after trying {} candidates", label, candidates.len())
        ).into())
    }

    fn name2id(&self, msg_db: &Path, msg_key: &str) -> Result<Vec<(i64, String)>> {
        let rows = run_rows(msg_db, msg_key, "SELECT rowid, user_name FROM Name2Id;")?;
        Ok(rows
            .into_iter()
            .filter_map(|row| {
                if row.len() < 2 {
                    return None;
                }
                Some((row[0].parse().ok()?, row[1].clone()))
            })
            .collect())
    }
}

fn sync_sqlite_sidecars(src: &Path, dst: &Path) -> Result<()> {
    for suffix in ["-wal", "-shm", "-journal"] {
        let src_sidecar = append_suffix(src, suffix);
        let dst_sidecar = append_suffix(dst, suffix);

        if src_sidecar.exists() {
            fs::copy(&src_sidecar, &dst_sidecar)?;
        } else if dst_sidecar.exists() {
            fs::remove_file(&dst_sidecar)?;
        }
    }

    Ok(())
}

fn append_suffix(path: &Path, suffix: &str) -> PathBuf {
    let mut value = path.as_os_str().to_os_string();
    value.push(suffix);
    PathBuf::from(value)
}

fn newest_account_dir(home: &Path) -> Option<PathBuf> {
    let root = home.join("xwechat_files");
    let mut newest: Option<(SystemTime, PathBuf)> = None;

    for entry in fs::read_dir(root).ok()?.flatten() {
        let dir = entry.path();
        if !dir.is_dir() {
            continue;
        }

        let db = dir.join("db_storage/message/message_0.db");
        let Ok(modified) = db.metadata().and_then(|meta| meta.modified()) else {
            continue;
        };
        if newest
            .as_ref()
            .map(|(current, _)| modified > *current)
            .unwrap_or(true)
        {
            newest = Some((modified, dir));
        }
    }

    newest.map(|(_, dir)| dir)
}

fn wait_for_message_change(home: &Path) -> Result<()> {
    let dirs = message_dirs(home);
    if dirs.is_empty() {
        thread::sleep(Duration::from_secs(2));
        return Ok(());
    }

    let fd = unsafe { inotify_init1(0) };
    if fd < 0 {
        thread::sleep(Duration::from_secs(2));
        return Ok(());
    }

    for dir in dirs {
        let c_path = CString::new(dir.as_os_str().as_encoded_bytes())?;
        let mask = IN_CLOSE_WRITE | IN_MODIFY | IN_CREATE | IN_MOVED_TO | IN_DELETE;
        unsafe {
            inotify_add_watch(fd, c_path.as_ptr(), mask);
        }
    }

    let mut file = unsafe { File::from_raw_fd(fd) };
    let mut buf = [0u8; 4096];
    let _ = file.read(&mut buf);
    Ok(())
}

fn message_dirs(home: &Path) -> Vec<PathBuf> {
    let root = home.join("xwechat_files");
    let mut dirs = Vec::new();

    let Ok(entries) = fs::read_dir(root) else {
        return dirs;
    };

    for entry in entries.flatten() {
        let dir = entry.path().join("db_storage/message");
        if dir.is_dir() {
            dirs.push(dir);
        }
    }

    dirs
}

fn is_wechat_focused() -> bool {
    let output = Command::new("/run/current-system/sw/bin/niri")
        .args(["msg", "-j", "windows"])
        .output();
    let Ok(output) = output else {
        return false;
    };
    let text = String::from_utf8_lossy(&output.stdout);

    for object in json_objects(&text) {
        let app_id = object.contains("\"app_id\":\"wechat\"")
            || object.contains("\"app_id\": \"wechat\"");
        let focused = object.contains("\"is_focused\":true")
            || object.contains("\"is_focused\": true");
        if app_id && focused {
            return true;
        }
    }

    false
}

fn json_objects(input: &str) -> Vec<String> {
    let mut objects = Vec::new();
    let mut depth = 0i32;
    let mut start = None;
    let mut in_string = false;
    let mut escaped = false;

    for (idx, ch) in input.char_indices() {
        if in_string {
            if escaped {
                escaped = false;
            } else if ch == '\\' {
                escaped = true;
            } else if ch == '"' {
                in_string = false;
            }
            continue;
        }

        match ch {
            '"' => in_string = true,
            '{' => {
                if depth == 0 {
                    start = Some(idx);
                }
                depth += 1;
            }
            '}' => {
                depth -= 1;
                if depth == 0 {
                    if let Some(start) = start.take() {
                        objects.push(input[start..=idx].to_string());
                    }
                }
            }
            _ => {}
        }
    }

    objects
}

fn run_rows(db: &Path, key: &str, sql: &str) -> Result<Vec<Vec<String>>> {
    let script = format!(
        ".bail on\nPRAGMA key = \"x'{key}'\";\nPRAGMA cipher_compatibility = 4;\n.mode tabs\n.headers off\n{sql}\n"
    );
    let mut child = Command::new("sqlcipher")
        .arg(db)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()?;

    child
        .stdin
        .as_mut()
        .ok_or_else(|| io::Error::new(io::ErrorKind::BrokenPipe, "sqlcipher stdin unavailable"))?
        .write_all(script.as_bytes())?;

    let output = child.wait_with_output()?;
    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(io::Error::other(stderr.trim().to_string()).into());
    }

    let stdout = String::from_utf8_lossy(&output.stdout);
    Ok(stdout
        .lines()
        .filter(|line| !line.trim().is_empty() && line.trim() != "ok")
        .map(|line| line.split('\t').map(ToString::to_string).collect())
        .collect())
}

fn validate_key(db: &Path, key: &str) -> bool {
    run_rows(db, key, "SELECT count(*) FROM sqlite_master;")
        .ok()
        .and_then(|rows| rows.into_iter().flatten().find_map(|cell| cell.parse::<i64>().ok()))
        .is_some()
}

fn known_message_tables(
    msg_db: &Path,
    msg_key: &str,
    names: &[(i64, String)],
) -> Result<Vec<(String, String)>> {
    let table_rows = run_rows(
        msg_db,
        msg_key,
        "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'Msg_%';",
    )?;
    let tables: HashSet<String> = table_rows
        .into_iter()
        .filter_map(|row| row.into_iter().next())
        .collect();

    let mut known = Vec::new();
    for (_, user) in names {
        let table = format!("Msg_{}", md5_hex(user.as_bytes()));
        if tables.contains(&table) {
            known.push((user.clone(), table));
        }
    }

    Ok(known)
}

fn id_to_user(names: &[(i64, String)]) -> HashMap<i64, String> {
    names.iter().map(|(id, name)| (*id, name.clone())).collect()
}

fn muted_chatrooms(contact_db: &Path, contact_key: &str) -> Result<HashSet<String>> {
    let rows = run_rows(
        contact_db,
        contact_key,
        "SELECT username FROM contact WHERE username LIKE '%@chatroom' AND chat_room_notify = 0;",
    )?;
    Ok(rows
        .into_iter()
        .filter_map(|row| row.into_iter().next())
        .collect())
}

fn mark_current_seen(
    msg_db: &Path,
    msg_key: &str,
    known: &[(String, String)],
    state: &mut HashMap<String, Cursor>,
) -> Result<()> {
    if known.is_empty() {
        return Ok(());
    }

    let selects: Vec<String> = known
        .iter()
        .map(|(chat, table)| {
            format!(
                "SELECT {} AS chat, create_time AS seen_time, local_id AS seen_id FROM (SELECT create_time, local_id FROM {} WHERE {} ORDER BY create_time DESC, local_id DESC LIMIT 1)",
                sql_quote(chat),
                table,
                SUPPORTED_MESSAGE_SQL
            )
        })
        .collect();
    let sql = format!(
        "SELECT chat, seen_time, seen_id FROM ({});",
        selects.join(" UNION ALL ")
    );

    for row in run_rows(msg_db, msg_key, &sql)? {
        if row.len() < 3 {
            continue;
        }
        let time = row[1].parse().unwrap_or(0);
        let id = row[2].parse().unwrap_or(0);
        state.insert(row[0].clone(), Cursor { time, id });
    }

    Ok(())
}

fn query_next_message(
    msg_db: &Path,
    msg_key: &str,
    known: &[(String, String)],
    muted: &HashSet<String>,
    state: &HashMap<String, Cursor>,
    own_id: i64,
) -> Result<Vec<MessageRow>> {
    let mut selects = Vec::new();

    for (chat, table) in known {
        if muted.contains(chat) {
            continue;
        }

        let cursor = state.get(chat).copied().unwrap_or_default();
        let sender_filter = if chat == "filehelper" {
            String::new()
        } else {
            format!("AND real_sender_id != {own_id} ")
        };

        selects.push(format!(
            "SELECT {} AS chat, local_id, local_type, real_sender_id, create_time, hex(message_content) AS content_hex FROM {} WHERE {} {}AND (create_time > {} OR (create_time = {} AND local_id > {}))",
            sql_quote(chat),
            table,
            SUPPORTED_MESSAGE_SQL,
            sender_filter,
            cursor.time,
            cursor.time,
            cursor.id
        ));
    }

    if selects.is_empty() {
        return Ok(Vec::new());
    }

    let sql = format!(
        "SELECT chat, local_id, local_type, real_sender_id, create_time, content_hex FROM ({}) ORDER BY create_time ASC, local_id ASC LIMIT 1;",
        selects.join(" UNION ALL ")
    );

    let rows = run_rows(msg_db, msg_key, &sql)?;
    Ok(rows
        .into_iter()
        .filter_map(|row| {
            if row.len() < 6 {
                return None;
            }
            Some(MessageRow {
                chat: row[0].clone(),
                local_id: row[1].parse().ok()?,
                local_type: row[2].parse().ok()?,
                real_sender_id: row[3].parse().ok()?,
                create_time: row[4].parse().ok()?,
                content: decode_hex(&row[5]).unwrap_or_default(),
            })
        })
        .collect())
}

fn format_message(
    contact_db: &Path,
    contact_key: &str,
    session_db: Option<&Path>,
    session_key: Option<&str>,
    chat: &str,
    sender_user: &str,
    local_type: i64,
    content: &str,
) -> Option<String> {
    let mut sender_user = sender_user.to_string();
    let mut body = content.to_string();

    if chat.ends_with("@chatroom") {
        if let Some((raw_sender, rest)) = body.split_once(":\n") {
            sender_user = raw_sender.to_string();
            body = rest.to_string();
        }
    }

    let summary = message_summary(local_type, &body)?;
    let sender_display = display_name(contact_db, contact_key, &sender_user)
        .unwrap_or_else(|| sender_user.clone());
    let chat_display = session_db
        .zip(session_key)
        .and_then(|(db, key)| session_display_name(db, key, chat))
        .or_else(|| display_name(contact_db, contact_key, chat))
        .unwrap_or_else(|| chat.to_string());

    let prefix = if chat.ends_with("@chatroom") {
        if chat_display != chat {
            format!("{chat_display} / {sender_display}")
        } else if !sender_display.is_empty() {
            sender_display
        } else {
            "群聊".to_string()
        }
    } else {
        chat_display
    };

    Some(format!("{prefix}: {summary}"))
}

fn message_summary(local_type: i64, content: &str) -> Option<String> {
    let base = local_type & MESSAGE_TYPE_MASK;

    match base {
        TEXT_TYPE | 10000 => {
            let text = clean_text(content);
            if text.is_empty() {
                None
            } else {
                Some(text)
            }
        }
        3 => Some("[图片]".to_string()),
        34 => Some("[语音]".to_string()),
        43 => Some("[视频]".to_string()),
        47 => Some("[表情]".to_string()),
        49 => Some(app_message_summary(local_type, content)),
        50 => Some("[通话]".to_string()),
        _ => Some("[消息]".to_string()),
    }
}

fn app_message_summary(local_type: i64, content: &str) -> String {
    let app_type = local_type >> 32;

    match app_type {
        3 => with_optional_title("[音乐]", content),
        4 => with_optional_title("[视频]", content),
        5 => with_optional_title("[链接]", content),
        6 => with_optional_title("[文件]", content),
        8 => "[表情]".to_string(),
        17 => "[位置共享]".to_string(),
        19 => with_optional_title("[聊天记录]", content),
        33 | 36 => with_optional_title("[小程序]", content),
        50 | 51 | 63 => with_optional_title("[视频号]", content),
        57 => with_optional_title("[引用消息]", content),
        62 => with_optional_title("[视频号/直播]", content),
        2000 => "[转账]".to_string(),
        2001 => "[红包]".to_string(),
        _ if content.contains("转账") => "[转账]".to_string(),
        _ if content.contains("红包") => "[红包]".to_string(),
        _ => with_optional_title("[文件/链接]", content),
    }
}

fn with_optional_title(label: &str, content: &str) -> String {
    if let Some(title) = xml_tag(content, "title") {
        let title = clean_text(&title);
        if !title.is_empty() {
            return format!("{label} {title}");
        }
    }

    label.to_string()
}

fn xml_tag(content: &str, tag: &str) -> Option<String> {
    let start = format!("<{tag}>");
    let end = format!("</{tag}>");
    let after_start = content.split_once(&start)?.1;
    let value = after_start.split_once(&end)?.0;

    Some(decode_xml_entities(value))
}

fn decode_xml_entities(input: &str) -> String {
    input
        .replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&amp;", "&")
        .replace("&quot;", "\"")
        .replace("&apos;", "'")
}

fn clean_text(input: &str) -> String {
    let mut text = input
        .replace("\r\n", "\n")
        .replace('\r', "\n")
        .trim()
        .chars()
        .filter(|ch| *ch == '\n' || *ch == '\t' || !ch.is_control())
        .collect::<String>();

    while text.contains("\n\n\n") {
        text = text.replace("\n\n\n", "\n\n");
    }

    if text.chars().count() > 180 {
        text = text.chars().take(177).collect::<String>();
        text = format!("{}...", text.trim_end());
    }

    text
}

fn display_name(contact_db: &Path, contact_key: &str, username: &str) -> Option<String> {
    if username.is_empty() {
        return None;
    }

    let sql = format!(
        "SELECT hex(CASE WHEN remark IS NOT NULL AND length(remark) > 0 THEN remark WHEN nick_name IS NOT NULL AND length(nick_name) > 0 THEN nick_name ELSE username END) FROM contact WHERE username = {} LIMIT 1;",
        sql_quote(username)
    );
    first_hex_cell(contact_db, contact_key, &sql)
}

fn session_display_name(session_db: &Path, session_key: &str, username: &str) -> Option<String> {
    if username.is_empty() {
        return None;
    }

    let sql = format!(
        "SELECT hex(session_title) FROM SessionNoContactInfoTable WHERE username = {} LIMIT 1;",
        sql_quote(username)
    );
    first_hex_cell(session_db, session_key, &sql)
}

fn first_hex_cell(db: &Path, key: &str, sql: &str) -> Option<String> {
    run_rows(db, key, sql)
        .ok()?
        .into_iter()
        .flatten()
        .find_map(|cell| decode_hex(&cell))
        .filter(|value| !value.is_empty())
}

fn notify(body: &str) {
    let _ = Command::new("notify-send")
        .args([
            "--app-name=WeChat",
            "--icon=com.tencent.wechat",
            "微信",
            body,
        ])
        .status();
}

fn load_key_cache(path: &Path) -> HashMap<String, String> {
    let mut map = HashMap::new();
    let Ok(content) = fs::read_to_string(path) else {
        return map;
    };

    for line in content.lines() {
        if let Some((key, value)) = line.split_once('=') {
            map.insert(key.to_string(), value.trim().to_string());
        }
    }

    map
}

fn save_key_cache(path: &Path, map: &HashMap<String, String>) -> Result<()> {
    let tmp = path.with_extension("tmp");
    let mut content = String::new();
    for (key, value) in map {
        content.push_str(key);
        content.push('=');
        content.push_str(value);
        content.push('\n');
    }
    fs::write(&tmp, content)?;
    fs::set_permissions(&tmp, fs::Permissions::from_mode(0o600))?;
    fs::rename(tmp, path)?;
    Ok(())
}

fn load_state(path: &Path) -> HashMap<String, Cursor> {
    let mut state = HashMap::new();
    let Ok(content) = fs::read_to_string(path) else {
        return state;
    };

    for line in content.lines() {
        let mut parts = line.split('\t');
        let (Some(chat), Some(time), Some(id)) = (parts.next(), parts.next(), parts.next()) else {
            continue;
        };
        let (Ok(time), Ok(id)) = (time.parse(), id.parse()) else {
            continue;
        };
        state.insert(chat.to_string(), Cursor { time, id });
    }

    state
}

fn save_state(path: &Path, state: &HashMap<String, Cursor>) -> Result<()> {
    let tmp = path.with_extension("tmp");
    let mut content = String::new();
    for (chat, cursor) in state {
        content.push_str(chat);
        content.push('\t');
        content.push_str(&cursor.time.to_string());
        content.push('\t');
        content.push_str(&cursor.id.to_string());
        content.push('\n');
    }
    fs::write(&tmp, content)?;
    fs::set_permissions(&tmp, fs::Permissions::from_mode(0o600))?;
    fs::rename(tmp, path)?;
    Ok(())
}

fn memory_candidates() -> Vec<String> {
    let mut seen = Vec::new();
    for pid in wechat_pids() {
        let maps = readable_maps(pid);
        let Ok(mem) = File::open(format!("/proc/{pid}/mem")) else {
            continue;
        };

        for (start, end) in maps {
            scan_mem_range(&mem, start, end, &mut seen);
        }
    }
    seen
}

fn wechat_pids() -> Vec<i32> {
    let uid = current_uid();
    let self_pid = std::process::id() as i32;
    let mut pids = Vec::new();
    let Ok(entries) = fs::read_dir("/proc") else {
        return pids;
    };

    for entry in entries.flatten() {
        let name = entry.file_name();
        let Some(name) = name.to_str() else {
            continue;
        };
        let Ok(pid) = name.parse::<i32>() else {
            continue;
        };
        if pid == self_pid {
            continue;
        }
        let proc_dir = entry.path();
        if proc_uid(&proc_dir) != Some(uid) {
            continue;
        }

        let comm = fs::read_to_string(proc_dir.join("comm")).unwrap_or_default().trim().to_string();
        let cmdline = fs::read(proc_dir.join("cmdline")).unwrap_or_default();
        if comm == "wechat" || cmdline.windows(b"com.tencent.wechat/files/wechat".len()).any(|w| {
            w == b"com.tencent.wechat/files/wechat"
        }) || cmdline.windows(b"WeChatAppEx".len()).any(|w| w == b"WeChatAppEx")
        {
            pids.push(pid);
        }
    }

    pids
}

fn current_uid() -> u32 {
    proc_uid(Path::new("/proc/self")).unwrap_or(0)
}

fn proc_uid(proc_dir: &Path) -> Option<u32> {
    let status = fs::read_to_string(proc_dir.join("status")).ok()?;
    for line in status.lines() {
        if let Some(rest) = line.strip_prefix("Uid:") {
            return rest.split_whitespace().next()?.parse().ok();
        }
    }
    None
}

fn readable_maps(pid: i32) -> Vec<(u64, u64)> {
    let mut maps = Vec::new();
    let Ok(content) = fs::read_to_string(format!("/proc/{pid}/maps")) else {
        return maps;
    };

    for line in content.lines() {
        let mut parts = line.split_whitespace();
        let Some(range) = parts.next() else {
            continue;
        };
        let Some(perms) = parts.next() else {
            continue;
        };
        if !perms.contains('r') {
            continue;
        }
        let Some((start, end)) = range.split_once('-') else {
            continue;
        };
        let (Ok(start), Ok(end)) = (u64::from_str_radix(start, 16), u64::from_str_radix(end, 16))
        else {
            continue;
        };
        if end > start && end - start <= 128 * 1024 * 1024 {
            maps.push((start, end));
        }
    }

    maps
}

fn scan_mem_range(mem: &File, start: u64, end: u64, seen: &mut Vec<String>) {
    const CHUNK: usize = 1024 * 1024;
    const OVERLAP: usize = 128;

    let mut offset = start;
    let mut carry = Vec::new();
    while offset < end {
        let len = usize::try_from((end - offset).min(CHUNK as u64)).unwrap_or(CHUNK);
        let mut buf = vec![0u8; len];
        let Ok(read) = mem.read_at(&mut buf, offset) else {
            break;
        };
        buf.truncate(read);
        if read == 0 {
            break;
        }

        let mut scan = carry;
        scan.extend_from_slice(&buf);
        collect_keys(&scan, seen);
        carry = scan
            .iter()
            .rev()
            .take(OVERLAP)
            .copied()
            .collect::<Vec<_>>();
        carry.reverse();

        offset += read as u64;
    }
}

fn collect_keys(data: &[u8], seen: &mut Vec<String>) {
    let mut i = 0;
    while i + 3 < data.len() {
        if data[i] == b'x' && data[i + 1] == b'\'' {
            let start = i + 2;
            let mut j = start;
            while j < data.len() && (data[j] as char).is_ascii_hexdigit() {
                j += 1;
            }
            if j < data.len() && data[j] == b'\'' {
                let len = j - start;
                if len == 64 || len == 96 {
                    let key = String::from_utf8_lossy(&data[start..j]).to_ascii_lowercase();
                    if !seen.contains(&key) {
                        seen.push(key);
                    }
                }
                i = j;
            } else {
                i += 1;
            }
        } else {
            i += 1;
        }
    }
}

fn sql_quote(value: &str) -> String {
    format!("'{}'", value.replace('\'', "''"))
}

fn decode_hex(input: &str) -> Option<String> {
    if input.len() % 2 != 0 {
        return None;
    }

    let mut bytes = Vec::with_capacity(input.len() / 2);
    let chars = input.as_bytes();
    for chunk in chars.chunks(2) {
        let hi = hex_value(chunk[0])?;
        let lo = hex_value(chunk[1])?;
        bytes.push((hi << 4) | lo);
    }

    Some(String::from_utf8_lossy(&bytes).to_string())
}

fn hex_value(byte: u8) -> Option<u8> {
    match byte {
        b'0'..=b'9' => Some(byte - b'0'),
        b'a'..=b'f' => Some(byte - b'a' + 10),
        b'A'..=b'F' => Some(byte - b'A' + 10),
        _ => None,
    }
}

fn md5_hex(input: &[u8]) -> String {
    let digest = md5(input);
    digest.iter().map(|byte| format!("{byte:02x}")).collect()
}

fn md5(input: &[u8]) -> [u8; 16] {
    const S: [u32; 64] = [
        7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14, 20, 5,
        9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11,
        16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10,
        15, 21,
    ];
    const K: [u32; 64] = [
        0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a,
        0xa8304613, 0xfd469501, 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
        0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821, 0xf61e2562, 0xc040b340,
        0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
        0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8,
        0x676f02d9, 0x8d2a4c8a, 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
        0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70, 0x289b7ec6, 0xeaa127fa,
        0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
        0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92,
        0xffeff47d, 0x85845dd1, 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
        0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    ];

    let mut message = input.to_vec();
    let bit_len = (message.len() as u64) * 8;
    message.push(0x80);
    while message.len() % 64 != 56 {
        message.push(0);
    }
    message.extend_from_slice(&bit_len.to_le_bytes());

    let mut a0 = 0x67452301u32;
    let mut b0 = 0xefcdab89u32;
    let mut c0 = 0x98badcfeu32;
    let mut d0 = 0x10325476u32;

    for chunk in message.chunks(64) {
        let mut m = [0u32; 16];
        for (idx, word) in m.iter_mut().enumerate() {
            let start = idx * 4;
            *word = u32::from_le_bytes([
                chunk[start],
                chunk[start + 1],
                chunk[start + 2],
                chunk[start + 3],
            ]);
        }

        let mut a = a0;
        let mut b = b0;
        let mut c = c0;
        let mut d = d0;

        for i in 0..64 {
            let (f, g) = if i < 16 {
                ((b & c) | ((!b) & d), i)
            } else if i < 32 {
                ((d & b) | ((!d) & c), (5 * i + 1) % 16)
            } else if i < 48 {
                (b ^ c ^ d, (3 * i + 5) % 16)
            } else {
                (c ^ (b | !d), (7 * i) % 16)
            };

            let tmp = d;
            d = c;
            c = b;
            b = b.wrapping_add(
                a.wrapping_add(f)
                    .wrapping_add(K[i])
                    .wrapping_add(m[g])
                    .rotate_left(S[i]),
            );
            a = tmp;
        }

        a0 = a0.wrapping_add(a);
        b0 = b0.wrapping_add(b);
        c0 = c0.wrapping_add(c);
        d0 = d0.wrapping_add(d);
    }

    let mut out = [0u8; 16];
    out[0..4].copy_from_slice(&a0.to_le_bytes());
    out[4..8].copy_from_slice(&b0.to_le_bytes());
    out[8..12].copy_from_slice(&c0.to_le_bytes());
    out[12..16].copy_from_slice(&d0.to_le_bytes());
    out
}
