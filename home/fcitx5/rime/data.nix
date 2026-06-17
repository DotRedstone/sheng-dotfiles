# ---
# Module: Rime Data
# Description: Symlinking external Rime data (like rime-ice lua scripts)
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  home.file.".local/share/fcitx5/rime/lua" = {
    source = "${pkgs.rime-ice}/share/rime-data/lua";
    recursive = true;
    force = true;
  };
}
