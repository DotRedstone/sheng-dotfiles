# ---
# Module: NixVim - Options
# Description: Editor options and clipboard provider settings
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim = {
    opts = {
      # UI
      number = true;
      relativenumber = true;
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      laststatus = 3;
      cmdheight = 0;
      pumblend = 10;
      pumheight = 10;
      winblend = 0;
      scrolloff = 6;
      sidescrolloff = 8;
      conceallevel = 2;
      showmode = false;
      showtabline = 2;
      wrap = false;
      linebreak = true;
      list = true;
      listchars = "tab:  ,trail:.,extends:>,precedes:<,nbsp:+";
      fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      inccommand = "nosplit";

      # Indentation and formatting
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      shiftround = true;
      breakindent = true;
      formatoptions = "jcroqlnt";

      # Behavior
      mouse = "a";
      autowrite = true;
      confirm = true;
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";
      virtualedit = "block";
      completeopt = "menu,menuone,noselect";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      jumpoptions = "view";

      # Undo, swap and session
      undofile = true;
      swapfile = false;
      backup = false;
      writebackup = false;
      sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";

      # Folds
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # Timing and clipboard
      updatetime = 200;
      timeout = true;
      timeoutlen = 300;
      clipboard = "unnamedplus";
    };

    clipboard.providers.wl-copy.enable = true;

    # Extra config that doesn't fit in opts
    extraConfigLuaPost = ''
      vim.o.winborder = "rounded"
    '';
  };
}
