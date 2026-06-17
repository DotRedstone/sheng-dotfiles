# ---
# Module: Rime Patch - Keybindings
# Description: Custom key bindings for candidate selection and menu navigation
# Scope: Home Manager
# ---

{
  "key_binder/bindings/+" = [
    { when = "has_menu"; accept = "semicolon"; send = "2"; }
    { when = "has_menu"; accept = "apostrophe"; send = "3"; }
    { when = "has_menu"; accept = "Control_L"; send = "noop"; }
    { when = "has_menu"; accept = "Control_R"; send = "noop"; }
  ];
}
