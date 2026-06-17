# ---
# Module: WezTerm
# Description: GPU-accelerated terminal emulator with Lua configuration
# Scope: Home Manager
# ---

{ ... }:

{
  programs.wezterm.enable = true;

  # [Configuration Link]
  # Symlinking for live-reloading without home-manager activation
  # 'force = true' ensures we overwrite any existing regular files at these paths
  xdg.configFile."wezterm/wezterm.lua" = {
    source = ./config.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/visuals.lua" = {
    source = ./modules/visuals.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/ui.lua" = {
    source = ./modules/ui.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/performance.lua" = {
    source = ./modules/performance.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/theme.lua" = {
    source = ./modules/theme.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/ssh.lua" = {
    source = ./modules/ssh.lua;
    force = true;
  };

  xdg.configFile."wezterm/modules/keybindings.lua" = {
    source = ./modules/keybindings.lua;
    force = true;
  };
}
