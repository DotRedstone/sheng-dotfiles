-- ---
-- Module: WezTerm - SSH
-- Description: SSH domains for remote terminal access
-- Scope: Home Manager
-- ---

local M = {}

function M.apply(config, _)
  -- [SSH Domains]
  config.ssh_domains = {
    { name = 'Beacon (HK)',    remote_address = 'beacon',   username = 'dot' },
    { name = 'Conduit (RN)',   remote_address = 'conduit',  username = 'dot' },
    { name = 'Hopper (Oracle)', remote_address = 'hopper',   username = 'dot' },
    { name = 'Target (Tencent)', remote_address = 'target',  username = 'dot' },
    { name = 'Repeater (Aliyun)',remote_address = 'repeater', username = 'dot' },
  }
end

return M
