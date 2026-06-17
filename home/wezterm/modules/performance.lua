-- ---
-- Module: WezTerm - Performance
-- Description: Wayland backend and balanced rendering settings
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  -- [Performance & Backend]
  config.enable_wayland = true
  config.front_end = "OpenGL"
end

return M
