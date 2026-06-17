# ---
# Module: NixVim - Autocommands
# Description: Global autocommands for terminal resizing, highlighting, and filetype behavior
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.autoCmd = [
    {
      event = "TextYankPost";
      callback.__raw = ''
        function()
          vim.highlight.on_yank({ timeout = 150 })
        end
      '';
    }
    {
      event = "VimResized";
      command = "tabdo wincmd =";
    }
    {
      event = "FileType";
      pattern = [
        "help" "man" "qf" "query" "notify" "checkhealth" "lspinfo" "startuptime"
      ];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Close window",
          })
        end
      '';
    }
    {
      event = "FileType";
      pattern = [ "gitcommit" "markdown" "text" ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      '';
    }
    {
      event = "BufWritePre";
      callback.__raw = ''
        function(event)
          if vim.bo[event.buf].buftype ~= "" then
            return
          end
          local name = vim.api.nvim_buf_get_name(event.buf)
          if name == "" then
            return
          end
          local dir = vim.fn.fnamemodify(name, ":p:h")
          if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
          end
        end
      '';
    }
  ];
}
