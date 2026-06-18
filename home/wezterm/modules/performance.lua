-- ---
-- Module: WezTerm - Performance
-- Description: XWayland backend and balanced rendering settings
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  -- [Performance & Backend]
  config.enable_wayland = false
  config.front_end = "OpenGL"
end

return M
