-- ---
-- Module: WezTerm - UI
-- Description: Tab bar, window decorations, and padding settings
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  -- [GNOME tablet UI]
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = false
  config.window_decorations = "TITLE | RESIZE"
  config.window_padding = {
    left = "1.5cell",
    right = "1.5cell",
    top = "1cell",
    bottom = "1cell",
  }
  config.window_close_confirmation = "AlwaysPrompt"
  config.adjust_window_size_when_changing_font_size = false
  config.initial_cols = 96
  config.initial_rows = 28
end

return M
