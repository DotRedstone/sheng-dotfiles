# ---
# Module: WeChat Desktop Entry
# Description: XDG desktop entry for WeChat UOS
# Scope: Home Manager
# ---

{ ... }: {
  xdg.desktopEntries."com.tencent.wechat" = {
    name = "微信 UOS";
    genericName = "WeChat UOS";
    comment = "微信桌面版 UOS";
    exec = "wechat-uos -- %U";
    icon = "com.tencent.wechat";
    terminal = false;
    categories = [ "Chat" ];
    startupNotify = true;
    settings = {
      StartupWMClass = "wechat";
    };
  };
}
