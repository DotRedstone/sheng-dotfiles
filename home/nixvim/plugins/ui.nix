# ---
# Module: NixVim - UI Plugins
# Description: Visual interface enhancements (Lualine, Bufferline, Noice, etc.)
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          globalstatus = true;
          component_separators = { left = ""; right = ""; };
          section_separators = { left = ""; right = ""; };
          disabled_filetypes.statusline = [ "dashboard" "alpha" "starter" ];
        };
        sections = {
          lualine_a = [{ __unkeyed-1 = "mode"; separator.right = ""; }];
          lualine_b = [ "branch" "diff" ];
          lualine_c = [{
            __unkeyed-1 = "filename";
            path = 1;
            symbols = { modified = " ●"; readonly = " "; unnamed = "[No Name]"; };
          }];
          lualine_x = [ "diagnostics" "encoding" "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [{ __unkeyed-1 = "location"; separator.left = ""; }];
        };
      };
    };

    bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        always_show_bufferline = false;
        separator_style = "thin";
        offsets = [{
          filetype = "neo-tree";
          text = "Explorer";
          highlight = "Directory";
          text_align = "left";
        }];
      };
    };

    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = true;
        };
      };
    };

    smear-cursor = {
      enable = true;
      # Settings are managed dynamically in colorscheme.nix to sync with Noctalia colors
    };

    notify.enable = true;
    dressing.enable = true;
    nui.enable = true;
    web-devicons.enable = true;
    illuminate.enable = true;
    aerial.enable = true;

    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope = { enabled = true; show_start = false; show_end = false; };
        exclude.filetypes = [
          "help" "alpha" "dashboard" "neo-tree" "Trouble" "lazy" "mason" "notify"
        ];
      };
    };
  };
}
