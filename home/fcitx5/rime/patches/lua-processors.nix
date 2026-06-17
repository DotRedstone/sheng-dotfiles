# ---
# Module: Rime Patch - Lua Processors
# Description: Configuration for mounting custom Lua processors in the Rime engine
# Scope: Home Manager
# ---

{
  "engine/processors/@before 0" = "lua_processor@select_character";
}
