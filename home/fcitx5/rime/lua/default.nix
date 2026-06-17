# ---
# Module: Rime Lua Entry
# Description: Entry point for Rime Lua scripts (rime.lua)
# Scope: Home Manager
# ---

{ ... }: {
  home.file.".local/share/fcitx5/rime/rime.lua".text = (import ./select-character.nix { }).rime_lua;
}
