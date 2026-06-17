# ---
# Module: Firefox - Native Messaging
# Description: External integrations for Firefox (Pywalfox, etc.)
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  # [Packages]
  home.packages = [ pkgs.pywalfox-native ];

  # [Native Messaging]
  # Required for Pywalfox to sync system colors with the browser
  home.file.".mozilla/native-messaging-hosts/pywalfox.json".text = builtins.toJSON {
    name = "pywalfox";
    description = "Pywalfox native messaging host";
    path = "${pkgs.pywalfox-native}/bin/pywalfox";
    type = "stdio";
    allowed_extensions = [ "pywalfox@frewacom.org" ];
  };
}
