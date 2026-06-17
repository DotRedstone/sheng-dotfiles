# ---
# Module: NixVim - Formatting and Linting
# Description: Conform.nvim for formatting and nvim-lint for static analysis
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python = [ "ruff_fix" "ruff_format" "ruff_organize_imports" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          zsh = [ "shfmt" ];
          fish = [ "fish_indent" ];
          javascript = [ "prettierd" "prettier" ];
          javascriptreact = [ "prettierd" "prettier" ];
          typescript = [ "prettierd" "prettier" ];
          typescriptreact = [ "prettierd" "prettier" ];
          vue = [ "prettierd" "prettier" ];
          css = [ "prettierd" "prettier" ];
          html = [ "prettierd" "prettier" ];
          json = [ "prettierd" "prettier" ];
          jsonc = [ "prettierd" "prettier" ];
          yaml = [ "prettierd" "prettier" ];
          markdown = [ "prettierd" "prettier" ];
          typst = [ "typstyle" ];
          toml = [ "taplo" ];
          cmake = [ "cmake_format" ];
        };
        notify_on_error = true;
        notify_no_formatters = false;
      };
    };

    lint = {
      enable = true;
      autoInstall.enable = true;
      lintersByFt = {
        markdown = [ "markdownlint" ];
        sh = [ "shellcheck" ];
        bash = [ "shellcheck" ];
        zsh = [ "shellcheck" ];
        dockerfile = [ "hadolint" ];
      };
    };
  };

  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>cf"; action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<cr>"; options.desc = "Format"; }
  ];

  programs.nixvim.extraConfigLuaPost = ''
    local lint_group = vim.api.nvim_create_augroup("dot_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_group,
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Enable autoformat-on-save" })
  '';
}
