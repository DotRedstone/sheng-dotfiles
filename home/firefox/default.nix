# ---
# Module: Firefox Switchboard
# Description: Unified entry point for Firefox profile, settings, theme, and integrations
# Scope: Home Manager
# ---

{ ... }: {
  imports = [
    ./profile.nix
    ./search.nix
    ./settings.nix
    ./theme.nix
    ./native-messaging.nix
    ./extensions.nix
  ];
}
