# ---
# Module: Zellij
# Description: Terminal workspace with static sheng theme and reusable layouts
# Scope: Home Manager
# ---

{ config, lib, ... }:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".source = ./config.kdl.template;

  xdg.configFile."zellij/layouts" = {
    force = true;
    source = ./layouts;
  };

  home.activation.replaceZellijLayoutsDir = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    target="${config.xdg.configHome}/zellij/layouts"
    if [ -d "$target" ] && [ ! -L "$target" ]; then
      if find "$target" -mindepth 1 -maxdepth 1 ! -type l | grep -q .; then
        echo "Refusing to replace $target because it contains non-symlink files." >&2
        exit 1
      fi
      rm -rf "$target"
    fi
  '';
}
