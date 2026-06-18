-- ---
-- Module: WezTerm - Theme
-- Description: Dynamic sheng palette with a Catppuccin fallback
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  local home = os.getenv('HOME')
  local theme_path = home and (home .. '/.config/wezterm/sheng-theme.lua') or nil

  if theme_path then
    local ok, dynamic_colors = pcall(dofile, theme_path)
    if ok and type(dynamic_colors) == 'table' then
      config.colors = dynamic_colors

      local frame_path = home .. '/.config/wezterm/sheng-frame.lua'
      local frame_ok, dynamic_frame = pcall(dofile, frame_path)
      if frame_ok and type(dynamic_frame) == 'table' then
        dynamic_frame.font_size = dynamic_frame.font_size or 13.5
        config.window_frame = dynamic_frame
      end

      return
    end
  end

  config.color_scheme = 'Catppuccin Mocha'
  config.window_frame = {
    font_size = 13.5,
  }
end

return M
