# ---
# Module: Network Tools
# Description: Network diagnostics and data processing
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  home.packages = with pkgs; [
    # [Diagnostics]
    iperf3
    nmap
    dig
    socat
    aria2 # Multi-threaded downloader

    # [Data Processing]
    jq
    yq-go
  ];
}
