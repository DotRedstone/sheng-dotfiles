# ---
# Module: Yazi
# Description: Blazing fast terminal file manager with Fish integration
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    # [Integrations]
    # Type 'y' in Fish to launch yazi and auto-cd on exit
    shellWrapperName = "y";
    enableFishIntegration = true;

    # [Configuration]
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "size";
      };

      preview = {
        max_width = 1000;
        max_height = 1000;
        cache_dir = "~/.cache/yazi";
      };
    };

    # [Keybindings]
    # Keep it minimal, matching Warden's ethos
    keymap = {
      manager.prepend_keymap = [
        { on = [ "g" "d" ]; run = "cd ~/sheng-dotfiles"; desc = "Go to sheng-dotfiles"; }
      ];
    };
  };

  # [Dependencies]
  # Tools for image/archive/code previewing within yazi
  home.packages = with pkgs; [
    file
    jq
    poppler      # PDF preview
    unzip
    p7zip        # 7z preview
    ffmpegthumbnailer # Video thumb
  ];
}
