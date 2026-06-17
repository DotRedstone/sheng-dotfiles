# ---
# Module: NixVim - Completion Plugins
# Description: Completion engine with Copilot and snippet support
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    blink-copilot.enable = true;
    blink-emoji.enable = true;
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        keymap = {
          preset = "none";
          "<Tab>" = [
            "snippet_forward"
            {
              __raw = ''
                function(cmp)
                  local is_open = false
                  if cmp.is_menu_visible and cmp.is_menu_visible() then
                    is_open = true
                  else
                    local ok, menu = pcall(require, "blink.cmp.completion.windows.menu")
                    if ok and menu.win and menu.win:is_open() then
                      is_open = true
                    end
                  end

                  if is_open then
                    cmp.select_next()
                    return true
                  end

                  local col = vim.fn.col(".") - 1
                  local has_words = col > 0 and vim.fn.getline("."):sub(col, col):match("%S") ~= nil
                  if has_words then
                    cmp.show()
                    return true
                  end
                end
              '';
            }
            "fallback"
          ];
          "<S-Tab>" = [ "snippet_backward" "select_prev" "fallback" ];
          "<Space>" = [
            {
              __raw = ''
                function(cmp)
                  if cmp.is_menu_visible and cmp.is_menu_visible() then
                    cmp.accept()
                    return true
                  end
                  local ok, menu = pcall(require, "blink.cmp.completion.windows.menu")
                  if ok and menu.win and menu.win:is_open() then
                    cmp.accept()
                    return true
                  end
                end
              '';
            }
            "fallback"
          ];
          "<CR>" = [ "fallback" ];
        };
        completion = {
          menu = { auto_show = false; border = "rounded"; };
          documentation = { auto_show = true; auto_show_delay_ms = 200; window.border = "rounded"; };
          list.selection = { preselect = true; auto_insert = false; };
          ghost_text.enabled = true;
        };
        signature = { enabled = true; window.border = "rounded"; };
        appearance = { use_nvim_cmp_as_default = true; nerd_font_variant = "normal"; };
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" "copilot" "emoji" ];
          providers = {
            copilot = { name = "copilot"; module = "blink-copilot"; score_offset = 100; async = true; };
            emoji = { name = "emoji"; module = "blink-emoji"; score_offset = 15; };
          };
        };
      };
    };

    friendly-snippets.enable = true;
    luasnip.enable = true;
  };
}
