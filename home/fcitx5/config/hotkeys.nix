# ---
# Module: Fcitx5 Hotkeys
# Description: Key bindings and trigger configuration
# Scope: Home Manager
# ---

{ ... }: {
  # Fcitx5 Hotkey settings
  hotkeys = ''
    [Hotkey]
    TriggerKeys=
    AltTriggerKeys=
    EnumerateForwardKeys=
    EnumerateBackwardKeys=
    EnumerateSkipFirstKeys=

    [Hotkey/TriggerKeys]
    0=Super+space
  '';
}
