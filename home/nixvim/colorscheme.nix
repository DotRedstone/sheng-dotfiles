# ---
# Module: NixVim - Colorscheme
# Description: Catppuccin theme with optional sheng dynamic palette overrides
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim = {
    colorschemes.catppuccin.enable = true;

    extraConfigLuaPre = ''
      vim.o.background = "dark"

      local function load_sheng_palette()
        local home = os.getenv("HOME")
        if not home then
          return {}
        end

        local path = home .. "/.cache/sheng-theme/nvim_colors.lua"
        local ok, palette = pcall(dofile, path)
        if ok and type(palette) == "table" then
          return palette
        end

        return {}
      end

      local sheng_palette = load_sheng_palette()
      local function pick(name, fallback)
        return sheng_palette[name] or fallback
      end

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        show_end_of_buffer = false,
        color_overrides = {
          mocha = {
            rosewater = pick("primary_soft", "#f5e0dc"),
            flamingo = pick("primary_soft", "#f2cdcd"),
            pink = pick("pink", "#f5c2e7"),
            mauve = pick("mauve", "#cba6f7"),
            red = pick("red", "#f38ba8"),
            maroon = pick("red", "#eba0ac"),
            peach = pick("peach", "#fab387"),
            yellow = pick("yellow", "#f9e2af"),
            green = pick("green", "#a6e3a1"),
            teal = pick("teal", "#94e2d5"),
            sky = pick("sky", "#89dceb"),
            sapphire = pick("secondary", "#74c7ec"),
            blue = pick("blue", "#89b4fa"),
            lavender = pick("lavender", "#b4befe"),
            text = pick("text", "#cdd6f4"),
            subtext1 = pick("subtext1", "#bac2de"),
            subtext0 = pick("subtext0", "#a6adc8"),
            overlay2 = pick("overlay2", "#9399b2"),
            overlay1 = pick("overlay1", "#7f849c"),
            overlay0 = pick("overlay0", "#6c7086"),
            surface2 = pick("surface2", "#585b70"),
            surface1 = pick("surface1", "#45475a"),
            surface0 = pick("surface0", "#313244"),
            base = pick("base", "#1e1e2e"),
            mantle = pick("mantle", "#181825"),
            crust = pick("crust", "#11111b"),
          },
        },
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
          cursor_color = pick("primary", "#cba6f7"),
          normal_bg = pick("base", "#1e1e2e"),
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
