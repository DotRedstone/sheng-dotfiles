# ---
# Module: Starship
# Description: Minimalist static shell prompt for sheng
# Scope: Home Manager
# ---

{ ... }: {

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./starship.toml.template;
}
