# ---
# Module: User Fonts
# Description: Installs local user fonts that are not available from nixpkgs
# Scope: Home Manager
# ---

{ ... }: {
  home.file = {
    ".local/share/fonts/mfga-selfuse/SELFUSE-300.ttf".source = ./mfga-selfuse/SELFUSE-300.ttf;
    ".local/share/fonts/mfga-selfuse/SELFUSE-400.ttf".source = ./mfga-selfuse/SELFUSE-400.ttf;
    ".local/share/fonts/mfga-selfuse/SELFUSE-700.ttf".source = ./mfga-selfuse/SELFUSE-700.ttf;
  };
}
