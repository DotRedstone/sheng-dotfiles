-- ---
-- Module: WezTerm - Keybindings
-- Description: Custom keyboard shortcuts for terminal management
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, wezterm)
  local act = wezterm.action

  -- [Keybindings]
  config.keys = {
    { key = 'S', mods = 'CTRL|SHIFT', action = act.ShowLauncher },
    { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
    { key = 'N', mods = 'CTRL|SHIFT', action = act.SpawnWindow },
    { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab{ confirm = true } },
  }
end

return M
