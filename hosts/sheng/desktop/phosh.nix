# Phosh Desktop Configuration (Mobile/Touch oriented)
{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.phosh.enable = true;
  
  # Enable Phosh's on-screen keyboard
  services.xserver.desktopManager.phosh.phocConfig = {
    keyboard-enabled = true;
  };
}
