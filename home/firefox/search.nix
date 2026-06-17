# ---
# Module: Firefox - Search
# Description: Search engine configuration and default policies
# Scope: Home Manager
# ---

{ ... }: {
  programs.firefox.profiles.dot = {
    search.force = true;
    search.default = "google";
    search.order = [ "google" ];
  };
}
