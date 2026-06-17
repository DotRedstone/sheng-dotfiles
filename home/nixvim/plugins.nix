# ---
# Module: Nixvim Plugins
# Description: Comprehensive plugin set mirroring the full LazyVim experience
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    # [UI Enhancements]
    lualine = {
      enable = true;
    };
    bufferline.enable = true;
    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        filesystem = {
          follow_current_file.enabled = true;
          filtered_items.visible = true;
        };
      };
    };
    noice.enable = true;
    notify.enable = true;
    web-devicons.enable = true;
    which-key = {
      enable = true;
      settings.spec = [
        { __unkeyed-1 = "<leader>b"; group = "+buffer"; }
        { __unkeyed-1 = "<leader>c"; group = "+code"; }
        { __unkeyed-1 = "<leader>f"; group = "+file"; }
        { __unkeyed-1 = "<leader>g"; group = "+git"; }
        { __unkeyed-1 = "<leader>q"; group = "+quit/session"; }
        { __unkeyed-1 = "<leader>s"; group = "+search"; }
        { __unkeyed-1 = "<leader>u"; group = "+ui"; }
        { __unkeyed-1 = "<leader>x"; group = "+diagnostics/quickfix"; }
      ];
    };
    indent-blankline.enable = true;

    # Git integration
    gitsigns = {
      enable = true;
      settings.signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "";
        topdelete.text = "";
        changedelete.text = "▎";
        untracked.text = "▎";
      };
    };

    # Symbols and Structure
    aerial.enable = true;

    # Dashboard (mini.starter handles this now)

    # Better UI components
    dressing.enable = true;
    nui.enable = true;
    illuminate.enable = true; # Highlight same words under cursor

    # [Search & Navigation]
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
      settings = {
        defaults = {
          layout_strategy = "horizontal";
          layout_config = { prompt_position = "top"; };
          sorting_strategy = "ascending";
          winblend = 0;
        };
      };
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
      };
    };

    flash = {
      enable = true;
      labels = "asdfghjklqwertyuiopzxcvbnm";
    };

    # [Coding & Editing]
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [
          "bash" "html" "javascript" "json" "lua" "markdown"
          "python" "tsx" "typescript" "vim" "yaml" "nix"
        ];
      };
    };

    # Auto-pairing, commenting, and startup
    mini = {
      enable = true;
      modules = {
        ai = {};    # Better text objects
        pairs = {}; # Auto pairs
        starter = {
          evaluate_single = true;
          header = ''
             _   _ ________   __     _____ __  __
            | \ | |_   _\ \ / /    _|_   _|  \/  |
            |  \| | | |  \ V /   / \  | | | |\/| |
            | |\  | | |   > <   / _ \ | | | |  | |
            |_| \_|___| /_/ \_\/_/ \_\___|_|  |_|
          '';
          items = [
            { name = "Find file"; action = "Telescope find_files"; section = "Telescope"; }
            { name = "Recent files"; action = "Telescope oldfiles"; section = "Telescope"; }
            { name = "Grep text"; action = "Telescope live_grep"; section = "Telescope"; }
            { name = "New file"; action = "ene | startinsert"; section = "Builtin"; }
            { name = "Quit"; action = "qa"; section = "Builtin"; }
          ];
        };
      };
    };
    comment.enable = true;
    vim-surround.enable = true;

    # [LSP & Formatting]
    lsp = {
      enable = true;
      servers = {
        # Original
        pyright.enable = true;
        ts_ls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        # Added from LazyVim Extras
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        jdtls.enable = true;
        volar.enable = true;
        tailwindcss.enable = true;
        clangd.enable = true;
        dockerls.enable = true;
        sqls.enable = true;
        marksman.enable = true;
        taplo.enable = true;
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gr" = "references";
        "gI" = "implementation";
        "K" = "hover";
        "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
        "<leader>cf" = "format";
      };
    };

    # None-ls for formatting/linting
    none-ls = {
      enable = true;
      sources = {
        formatting = {
          shfmt.enable = true;
          stylua.enable = true;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          # Added formatters
          markdownlint.enable = true;
          taplo.enable = true;
        };
        diagnostics = {
          shellcheck.enable = true;
          markdownlint.enable = true;
        };
      };
    };

    # [AI & Autocompletion]
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };
    copilot-cmp.enable = true;

    # [Autocompletion]
    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        sources = [
          { name = "copilot"; }
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "emoji"; }
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
      };
    };

    cmp-emoji.enable = true;
    cmp-nvim-lsp.enable = true;
    luasnip.enable = true;

    # [Utility]
    trouble.enable = true;
    todo-comments.enable = true;
    persistence.enable = true;
  };

  # Custom keymaps and logic for specific plugins
  programs.nixvim.keymaps = [
    {
      mode = [ "n" "o" ];
      key = "S";
      action = "<cmd>lua require('flash').treesitter()<cr>";
      options.desc = "Flash Treesitter";
    }
    {
      mode = [ "n" "x" "o" ];
      key = "s";
      action = "<cmd>lua require('flash').jump()<cr>";
      options.desc = "Flash";
    }
    { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Explorer"; }
    { mode = "n"; key = "<leader>E"; action = "<cmd>Neotree reveal<cr>"; options.desc = "Explorer Reveal"; }
    { mode = "n"; key = "<leader><space>"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find Files (Root)"; }
    { mode = "n"; key = "<leader>/"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Grep (Root)"; }
    { mode = "n"; key = "<leader>sg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Grep (Root)"; }
    { mode = "n"; key = "<leader>sh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "Help Pages"; }

    # Bufferline
    { mode = "n"; key = "<leader>bp"; action = "<cmd>BufferLineTogglePin<cr>"; options.desc = "Toggle Pin"; }
    { mode = "n"; key = "<leader>bP"; action = "<cmd>BufferLineGroupClose ungrouped<cr>"; options.desc = "Delete Non-Pinned Buffers"; }
    { mode = "n"; key = "<leader>br"; action = "<cmd>BufferLineCloseRight<cr>"; options.desc = "Delete Buffers to the Right"; }
    { mode = "n"; key = "<leader>bl"; action = "<cmd>BufferLineCloseLeft<cr>"; options.desc = "Delete Buffers to the Left"; }
    { mode = "n"; key = "<leader>bo"; action = "<cmd>BufferLineCloseOthers<cr>"; options.desc = "Delete Other Buffers"; }

    # Trouble
    { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<cr>"; options.desc = "Diagnostics (Trouble)"; }
    { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"; options.desc = "Buffer Diagnostics (Trouble)"; }
    { mode = "n"; key = "<leader>cs"; action = "<cmd>Trouble symbols toggle focus=false<cr>"; options.desc = "Symbols (Trouble)"; }
    { mode = "n"; key = "<leader>cl"; action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"; options.desc = "LSP Definitions / references / ... (Trouble)"; }
    { mode = "n"; key = "<leader>xL"; action = "<cmd>Trouble loclist toggle<cr>"; options.desc = "Location List (Trouble)"; }
    { mode = "n"; key = "<leader>xQ"; action = "<cmd>Trouble qflist toggle<cr>"; options.desc = "Quickfix List (Trouble)"; }

    # Git
    { mode = "n"; key = "<leader>ghb"; action = "<cmd>Gitsigns blame_line<cr>"; options.desc = "Blame Line"; }
    { mode = "n"; key = "<leader>ghR"; action = "<cmd>Gitsigns reset_buffer<cr>"; options.desc = "Reset Buffer"; }
    { mode = "n"; key = "<leader>ghr"; action = "<cmd>Gitsigns reset_hunk<cr>"; options.desc = "Reset Hunk"; }
    { mode = "n"; key = "<leader>ghs"; action = "<cmd>Gitsigns stage_hunk<cr>"; options.desc = "Stage Hunk"; }
    { mode = "n"; key = "<leader>ghu"; action = "<cmd>Gitsigns undo_stage_hunk<cr>"; options.desc = "Undo Stage Hunk"; }
  ];
}
