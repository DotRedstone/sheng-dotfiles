# ---
# Module: Rime Schema
# Description: Global Rime settings and schema selection (default.custom.yaml)
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source =
    (pkgs.formats.yaml { }).generate "default.custom.yaml" {
      patch = {
        schema_list = [ { schema = "rime_ice"; } ];
        "menu/page_size" = 10;
      };
    };
}
