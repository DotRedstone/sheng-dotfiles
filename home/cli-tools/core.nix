# ---
# Module: Core CLI Tools
# Description: Essential POSIX utilities and archiving tools
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  home.packages = with pkgs; [
    # [Archiving]
    zip
    unzip
    p7zip
    xz
    gnutar

    # [System Utilities]
    rsync
    file
    which
    tree
    gnused
    fastfetch
  ];
}
