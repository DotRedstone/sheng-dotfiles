# ---
# Module: NixVim - Keymaps
# Description: Global editor keybindings and leader mappings
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
      options.desc = "退出插入模式";
    }

    # Mac-style / Super shortcuts. The terminal must pass Super keys through.
    {
      mode = [ "n" "v" ];
      key = "<D-c>";
      action = "\"+y";
      options.desc = "复制到剪贴板";
    }
    {
      mode = "i";
      key = "<D-c>";
      action = "<Esc>\"+ygi";
      options.desc = "复制到剪贴板";
    }
    {
      mode = [ "n" "v" ];
      key = "<D-v>";
      action = "\"+p";
      options.desc = "从剪贴板粘贴";
    }
    {
      mode = "i";
      key = "<D-v>";
      action = "<C-r>+";
      options.desc = "从剪贴板粘贴";
    }
    {
      mode = [ "n" "v" "i" ];
      key = "<D-s>";
      action = "<cmd>w<cr>";
      options.desc = "保存文件";
    }
    {
      mode = [ "n" "v" ];
      key = "<D-a>";
      action = "ggVG";
      options.desc = "全选";
    }

    # Window management
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "切换到左侧窗口";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "切换到下方窗口";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "切换到上方窗口";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "切换到右侧窗口";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options.desc = "增加窗口高度";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options.desc = "减少窗口高度";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options.desc = "减少窗口宽度";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options.desc = "增加窗口宽度";
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<C-w>s";
      options.desc = "水平拆分窗口";
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<C-w>v";
      options.desc = "垂直拆分窗口";
    }
    {
      mode = "n";
      key = "<leader>wh";
      action = "<C-w>h";
      options.desc = "切到左窗口";
    }
    {
      mode = "n";
      key = "<leader>wj";
      action = "<C-w>j";
      options.desc = "切到下窗口";
    }
    {
      mode = "n";
      key = "<leader>wk";
      action = "<C-w>k";
      options.desc = "切到上窗口";
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = "<C-w>l";
      options.desc = "切到右窗口";
    }
    {
      mode = "n";
      key = "<leader>wv";
      action = "<C-w>v";
      options.desc = "垂直分屏";
    }
    {
      mode = "n";
      key = "<leader>ws";
      action = "<C-w>s";
      options.desc = "水平分屏";
    }
    {
      mode = "n";
      key = "<leader>wc";
      action = "<C-w>c";
      options.desc = "关闭窗口";
    }
    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-w>c";
      options.desc = "关闭当前窗口";
    }
    {
      mode = "n";
      key = "<leader>wo";
      action = "<C-w>o";
      options.desc = "只保留当前窗口";
    }
    {
      mode = "n";
      key = "<leader>w=";
      action = "<C-w>=";
      options.desc = "等分窗口";
    }
    {
      mode = "n";
      key = "<leader>wH";
      action = "<C-w>H";
      options.desc = "窗口移到左侧";
    }
    {
      mode = "n";
      key = "<leader>wJ";
      action = "<C-w>J";
      options.desc = "窗口移到底部";
    }
    {
      mode = "n";
      key = "<leader>wK";
      action = "<C-w>K";
      options.desc = "窗口移到顶部";
    }
    {
      mode = "n";
      key = "<leader>wL";
      action = "<C-w>L";
      options.desc = "窗口移到右侧";
    }

    # Buffers
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options.desc = "上一个标签页";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options.desc = "下一个标签页";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options.desc = "切换到最近缓冲区";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      options.desc = "删除当前缓冲区";
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>bd!<cr>";
      options.desc = "Delete buffer force";
    }

    # Files and sessions
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<cr>";
      options.desc = "保存当前文件";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options.desc = "关闭/退出";
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options.desc = "退出所有";
    }
    {
      mode = "n";
      key = "<leader>qQ";
      action = "<cmd>qa!<cr>";
      options.desc = "强制退出所有";
    }
    {
      mode = "n";
      key = "<leader>qs";
      action = "<cmd>lua require('persistence').load()<cr>";
      options.desc = "恢复会话";
    }
    {
      mode = "n";
      key = "<leader>ql";
      action = "<cmd>lua require('persistence').load({ last = true })<cr>";
      options.desc = "恢复最后一次会话";
    }
    {
      mode = "n";
      key = "<leader>qd";
      action = "<cmd>lua require('persistence').stop()<cr>";
      options.desc = "本次不保存会话";
    }

    # Movement and editing
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options.desc = "下移当前行";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options.desc = "上移当前行";
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options.desc = "下移当前行";
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options.desc = "上移当前行";
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options.desc = "下移选中行";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options.desc = "上移选中行";
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent left";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent right";
    }

    # Search and navigation
    {
      mode = [ "i" "n" ];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options.desc = "清除搜索高亮";
    }
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "跳转到下一个搜索结果";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "跳转到上一个搜索结果";
    }
  ];
}
