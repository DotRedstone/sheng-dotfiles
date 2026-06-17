# ---
# Module: NixVim - Git Plugins
# Description: Git integration and diff visualization tools
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "";
          topdelete.text = "";
          changedelete.text = "▎";
          untracked.text = "▎";
        };
        current_line_blame = false;
        current_line_blame_opts.delay = 500;
      };
    };
  };

  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>gg"; action = "<cmd>lua Snacks.lazygit()<cr>"; options.desc = "Lazygit (终端界面)"; }
    { mode = "n"; key = "<leader>gb"; action = "<cmd>lua Snacks.picker.git_branches()<cr>"; options.desc = "查看分支"; }
    { mode = "n"; key = "<leader>gc"; action = "<cmd>lua Snacks.picker.git_log()<cr>"; options.desc = "Git 日志"; }
    { mode = "n"; key = "<leader>gs"; action = "<cmd>lua Snacks.picker.git_status()<cr>"; options.desc = "Git 状态"; }
    { mode = "n"; key = "<leader>ghb"; action = "<cmd>Gitsigns blame_line<cr>"; options.desc = "行 Blame"; }
    { mode = "n"; key = "<leader>ghR"; action = "<cmd>Gitsigns reset_buffer<cr>"; options.desc = "重置整个文件"; }
    { mode = "n"; key = "<leader>ghr"; action = "<cmd>Gitsigns reset_hunk<cr>"; options.desc = "重置代码块"; }
    { mode = "n"; key = "<leader>ghs"; action = "<cmd>Gitsigns stage_hunk<cr>"; options.desc = "暂存代码块"; }
    { mode = "n"; key = "<leader>ghu"; action = "<cmd>Gitsigns undo_stage_hunk<cr>"; options.desc = "撤回暂存"; }
  ];
}
