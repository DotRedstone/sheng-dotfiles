# ---
# Module: NixVim - Packages
# Description: External Home Manager packages for editor tooling (formatters, linters)
# Scope: Home Manager
# ---

{ pkgs, ... }: {
  home.packages = with pkgs; [
    tree-sitter
    wl-clipboard

    # Formatters and linters used by conform.nvim / nvim-lint.
    alejandra
    nixfmt
    prettierd
    prettier
    stylua
    shfmt
    shellcheck
    markdownlint-cli
    taplo
    ruff
    black
    isort
    cmake-format
    typst
    typstyle
    tinymist
  ];
}
