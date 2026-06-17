# ---
# Module: Rime Lua Select Character
# Description: Custom Lua function for candidate selection using [ and ]
# Scope: Home Manager
# ---

{ ... }: {
  # Lua function to select character with [ and ]
  rime_lua = ''
    function select_character(key, env)
      local engine = env.engine
      local context = engine.context
      local k = key:repr()
      if context:is_composing() and (k == "bracketleft" or k == "bracketright") then
        local cand = context:get_selected_candidate() or context:get_candidate_list():to_table()[1]
        if cand then
          local text = cand.text
          if k == "bracketleft" then
            engine:commit_text(text:sub(1, utf8.offset(text, 2) - 1))
          else
            engine:commit_text(text:sub(utf8.offset(text, utf8.len(text))))
          end
          context:clear()
          return 1
        end
      end
      return 2
    end
  '';
}
