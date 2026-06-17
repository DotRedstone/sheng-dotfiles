# ---
# Module: Fcitx5 Environment
# Description: Global IM environment variables (GTK, QT, XMODIFIERS, etc.)
# Scope: Home Manager
# ---

{ ... }: {
  home.sessionVariables = {
    # Do not set GTK_IM_MODULE on Wayland; Fcitx5 recommends using the Wayland frontend for GTK apps.
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
}
