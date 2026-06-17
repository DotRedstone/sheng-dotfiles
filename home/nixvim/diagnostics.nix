# ---
# Module: NixVim - Diagnostics
# Description: Global diagnostics display and behavior configuration
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.diagnostic.settings = {
    virtual_text = {
      spacing = 4;
      source = "if_many";
      prefix = "●";
    };
    float = {
      border = "rounded";
      source = "always";
    };
    severity_sort = true;
    signs = {
      text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = "";
        "__rawKey__vim.diagnostic.severity.WARN" = "";
        "__rawKey__vim.diagnostic.severity.HINT" = "";
        "__rawKey__vim.diagnostic.severity.INFO" = "";
      };
    };
  };
}
