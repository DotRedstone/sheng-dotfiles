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
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.integrated_title_button_style = "Gnome"
  config.integrated_title_button_alignment = "Right"
  config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
  config.integrated_title_button_color = "Auto"
  config.show_tab_index_in_tab_bar = false
  config.window_padding = {
    left = "1.75cell",
    right = "1.75cell",
    top = "0.65cell",
    bottom = "0.9cell",
  }
  config.window_close_confirmation = "AlwaysPrompt"
  config.adjust_window_size_when_changing_font_size = false
  config.initial_cols = 96
  config.initial_rows = 28
  config.enable_scroll_bar = true
end

return M
