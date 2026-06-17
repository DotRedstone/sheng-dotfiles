-- ---
-- Module: WezTerm - Performance
-- Description: WebGPU backend and Wayland enablement
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  -- [Performance & Backend]
  config.front_end = "WebGpu"
  config.enable_wayland = true
  config.webgpu_power_preference = "HighPerformance"
end

return M
