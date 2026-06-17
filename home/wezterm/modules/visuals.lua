-- ---
-- Module: WezTerm - Visuals
-- Description: Font stack, opacity, and cursor animation settings
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, wezterm)
  -- [Visuals & Typography]
  config.font = wezterm.font_with_fallback({
    { family = 'Maple Mono NF', weight = 'Regular' },
    { family = 'Noto Sans CJK SC', weight = 'Regular' },
    { family = 'Symbols Nerd Font Mono', weight = 'Regular' },
  })
  config.font_size = 12
  config.window_background_opacity = 1.0

  -- [Animation & Cursor]
  config.default_cursor_style = "BlinkingBar"
  config.cursor_blink_ease_in = "EaseIn"
  config.cursor_blink_ease_out = "EaseOut"
  config.animation_fps = 165 -- Sync with your high refresh rate monitor
  config.cursor_thickness = "2pt"
  config.cursor_blink_rate = 500
end

return M
