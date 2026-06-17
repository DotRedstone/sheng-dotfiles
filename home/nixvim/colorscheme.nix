# ---
# Module: NixVim - Colorscheme
# Description: Static Catppuccin theme configuration for sheng
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim = {
    colorschemes.catppuccin.enable = true;

    extraConfigLuaPre = ''
      vim.o.background = "dark"

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        show_end_of_buffer = false,
        integrations = {
          aerial = true,
          blink_cmp = true,
          flash = true,
          gitsigns = true,
          illuminate = true,
          indent_blankline = {
            enabled = true,
          },
          lsp_trouble = true,
          lualine = true,
          markdown = true,
          mason = false,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          neotree = true,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          snacks = true,
          telescope = {
            enabled = true,
          },
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
        custom_highlights = function(colors)
          return {
            LineNr = { fg = colors.surface1 },
            CursorLineNr = { fg = colors.mauve, style = { "bold" } },
            Visual = { bg = colors.surface2, style = { "underline" } },
            PmenuSel = { bg = colors.surface2, style = { "bold" } },
            Pmenu = { fg = colors.text, bg = colors.surface0 },
            MatchParen = { bg = colors.surface2, style = { "bold", "underline" } },
            Comment = { fg = colors.subtext0, style = { "italic" } },
            Search = { bg = colors.surface1 },
            IncSearch = { bg = colors.surface2 },
            UnexpectedDelimiters = { fg = colors.red },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin-mocha")

      local smear_ok, smear_cursor = pcall(require, "smear-cursor")
      if smear_ok then
        smear_cursor.setup({
          cursor_color = "#cba6f7",
          normal_bg = "#1e1e2e",
          stiffness = 0.72,
          trailing_stiffness = 0.38,
          trailing_exponent = 2,
          distance_stop_animating = 0.08,
          time_interval = 17,
          delay_animation_start = 3,
          max_length = 28,
          color_levels = 16,
          smear_between_buffers = true,
          smear_between_neighbor_lines = true,
          smear_to_cmd = true,
          scroll_buffer_space = true,
          hide_target_hack = true,
          legacy_computing_symbols_support = false,
          transparent_bg_fallback_color = "303030",
        })
      end
    '';
  };
}
