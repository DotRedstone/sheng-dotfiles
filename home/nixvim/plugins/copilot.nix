# ---
# Module: NixVim - Copilot
# Description: GitHub Copilot core and Chat integration
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    # [Service]
    copilot-lua = {
      enable = true;
      copilotNodeCommand = "node --no-warnings";
      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
        filetypes = {
          markdown = true;
          help = true;
        };
      };
    };

    # [Chat]
    copilot-chat = {
      enable = true;
      settings = {
        show_help = true;
        question_header = "  User ";
        answer_header = "  Copilot ";
        error_header = "󰚑  Error ";
        separator = " ";
        prompts = {
          Explain = "Please explain the following code.";
          Review = "Please review the following code and provide suggestions.";
          Fix = "There is a bug in this code, please fix it.";
          Optimize = "Please optimize this code for performance and readability.";
          Docs = "Please add detailed comments to this code.";
          Tests = "Please write unit tests for this code.";
        };
      };
    };
  };

  # [Keybindings]
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>CopilotChatToggle<cr>";
      options = { desc = "开启/关闭 Copilot 聊天"; };
    }
    {
      mode = "v";
      key = "<leader>ce";
      action = "<cmd>CopilotChatExplain<cr>";
      options = { desc = "Copilot 解释代码"; };
    }
  ];
}
