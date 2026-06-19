# ---
# Module: Modern CLI & TUI Tools
# Description: Next-generation terminal utilities and file managers
# Scope: Home Manager
# ---

{ lib, pkgs, ... }:
let
  optionalPackage = name:
    lib.optional
      (lib.hasAttr name pkgs && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.${name})
      pkgs.${name};
in
{
  # Standard Packages (Tools without complex config modules)
  home.packages = with pkgs; [
    fd          # Modern find
    ripgrep     # Modern grep
    xh          # Modern curl
    btop        # System monitor
    duf
    dust
    nh
    nix-output-monitor

    # Aesthetics
    cmatrix

    # Note:
    # - Auth: ~/.local/share/opencode/auth.json
    # - Config: ~/.config/opencode/opencode.json
  ]
  ++ optionalPackage "cbonsai"
  ++ optionalPackage "pipes-rs"
  ++ optionalPackage "opencode";

  # [Modern Coreutils]

  # Eza: Modern replacement for ls
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  # Bat: Modern replacement for cat
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      italic-text = "always";
    };
  };

  # Zoxide: Modern replacement for cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # FZF: Command-line fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5e0dc";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5e0dc";
      "marker" = "#b4befe";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };

  # Tealdeer: Fast tldr client (man page replacement)
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = true;
      };
    };
  };

  # Lazygit: Git terminal UI
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [ "#cba6f7" "bold" ];
        inactiveBorderColor = [ "#6c7086" ];
        optionsTextColor = [ "#89b4fa" ];
        selectedLineBgColor = [ "#313244" ];
        cherryPickedCommitBgColor = [ "#313244" ];
        cherryPickedCommitFgColor = [ "#cba6f7" ];
        unstagedChangesColor = [ "#f38ba8" ];
        defaultFgColor = [ "#cdd6f4" ];
        searchingActiveBorderColor = [ "#f9e2af" ];
      };
    };
  };

  # [Fastfetch Config]
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.json;

  # [OpenCode Config]
  xdg.configFile."opencode/opencode.json".source = ./opencode.json;

  # Shell aliases to map classic commands to modern ones
  home.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -la";
    lt = "eza --tree";
    cat = "bat";
    cd = "z";
    grep = "rg";
    find = "fd";
  };
}
