# ---
# Module: Firefox - Extensions
# Description: Enterprise policy-based declarative extensions
# Scope: Home Manager
# ---

{ ... }: {
  programs.firefox.policies = {
    ExtensionSettings = {
      # Pywalfox
      "pywalfox@frewacom.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
        installation_mode = "force_installed";
      };
      # Bitwarden
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      # Dark Reader
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
      # Immersive Translate
      "immersive-translate@owenyoung.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/immersive-translate/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}
