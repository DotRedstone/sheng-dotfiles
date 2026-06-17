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
      return
    end
  end

  config.color_scheme = 'Catppuccin Mocha'
end

return M
