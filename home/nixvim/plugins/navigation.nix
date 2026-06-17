# ---
# Module: NixVim - Navigation Plugins
# Description: Navigation and key discovery tools (Flash, Which-key)
# Scope: Home Manager
# ---

{ ... }: {
  programs.nixvim.plugins = {
    flash = {
      enable = true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        modes.search.enabled = true;
      };
    };

    which-key = {
      enable = true;
      settings = {
        preset = "modern";
        delay = 250;
        spec = [
          { __unkeyed-1 = "<leader>b"; group = "󰓩 缓冲"; }
          { __unkeyed-1 = "<leader>c"; group = "󰅩 代码"; }
          { __unkeyed-1 = "<leader>f"; group = "󰈞 文件/查找"; }
          { __unkeyed-1 = "<leader>g"; group = "󰊢 Git"; }
          { __unkeyed-1 = "<leader>q"; group = "󰈆 退出/会话"; }
          { __unkeyed-1 = "<leader>s"; group = "󰍉 搜索/符号"; }
          { __unkeyed-1 = "<leader>u"; group = "󰙵 界面"; }
          { __unkeyed-1 = "<leader>w"; group = "󰖲 窗口"; }
          { __unkeyed-1 = "<leader>x"; group = "󰒡 诊断/修复"; }
          { __unkeyed-1 = "<leader>gh"; group = "󰊢 Hunk"; }

          # [Prefixes]
          { __unkeyed-1 = "g"; group = "󰒡 跳转/动作"; }
          { __unkeyed-1 = "gz"; group = "󰒡 环绕(Surround)"; }
          { __unkeyed-1 = "["; group = "󰮳 上一个"; }
          { __unkeyed-1 = "[b"; desc = "上一个缓冲区"; }
          { __unkeyed-1 = "[d"; desc = "上一个诊断"; }
          { __unkeyed-1 = "[e"; desc = "上一个错误"; }
          { __unkeyed-1 = "[q"; desc = "Quickfix 上一项"; }
          { __unkeyed-1 = "[t"; desc = "上一个标签页"; }
          { __unkeyed-1 = "[m"; desc = "上一个方法开始"; }
          { __unkeyed-1 = "[M"; desc = "上一个方法结束"; }

          { __unkeyed-1 = "]"; group = "󰮲 下一个"; }
          { __unkeyed-1 = "]b"; desc = "下一个缓冲区"; }
          { __unkeyed-1 = "]d"; desc = "下一个诊断"; }
          { __unkeyed-1 = "]e"; desc = "下一个错误"; }
          { __unkeyed-1 = "]q"; desc = "Quickfix 下一项"; }
          { __unkeyed-1 = "]t"; desc = "下一个标签页"; }
          { __unkeyed-1 = "]m"; desc = "下一个方法开始"; }
          { __unkeyed-1 = "]M"; desc = "下一个方法结束"; }

          { __unkeyed-1 = "z"; group = "󰁦 折叠"; }

          # [Hide noise]
          { __unkeyed-1 = "2LeftMouse"; hidden = true; }
          { __unkeyed-1 = "<2-LeftMouse>"; hidden = true; }
          { __unkeyed-1 = "matchup-double-click)"; hidden = true; }

          # [Common g motions]
          { __unkeyed-1 = "gh"; desc = "选择模式"; }
          { __unkeyed-1 = "gj"; desc = "向下移动(视口行)"; }
          { __unkeyed-1 = "gk"; desc = "向上移动(视口行)"; }
          { __unkeyed-1 = "gl"; desc = "跳转至行尾(非空字符)"; }
          { __unkeyed-1 = "gH"; desc = "选择行"; }
          { __unkeyed-1 = "gM"; desc = "跳转至行中"; }
          { __unkeyed-1 = "gr"; desc = "虚拟替换模式"; }
          { __unkeyed-1 = "ge"; desc = "跳转到上个词尾"; }
          { __unkeyed-1 = "gf"; desc = "打开光标下的文件"; }
          { __unkeyed-1 = "gg"; desc = "跳转到文件首行"; }
          { __unkeyed-1 = "gi"; desc = "跳转到上次插入位置"; }
          { __unkeyed-1 = "gn"; desc = "搜索并选中"; }
          { __unkeyed-1 = "gv"; desc = "选中上次可视区域"; }
          { __unkeyed-1 = "gw"; desc = "格式化当前行"; }
          { __unkeyed-1 = "gx"; desc = "调用系统默认程序打开"; }

          # [Directions in menus]
          { __unkeyed-1 = "h"; desc = "左"; }
          { __unkeyed-1 = "j"; desc = "下"; }
          { __unkeyed-1 = "k"; desc = "上"; }
          { __unkeyed-1 = "l"; desc = "右"; }
          { __unkeyed-1 = "M"; desc = "跳转至屏幕中间行"; }
          { __unkeyed-1 = "H"; desc = "跳转至屏幕顶行"; }
          { __unkeyed-1 = "L"; desc = "跳转至屏幕底行"; }

          # [Operators]
          { __unkeyed-1 = "c"; group = "󰏫 修改 (Change)"; }
          { __unkeyed-1 = "d"; group = "󰆴 删除 (Delete)"; }
          { __unkeyed-1 = "y"; group = "󰆏 复制 (Yank)"; }
          { __unkeyed-1 = "v"; group = "󰈈 可视模式"; }

          # [Text Objects]
          { __unkeyed-1 = "a"; group = "󰒡 包含 (Around)"; }
          { __unkeyed-1 = "i"; group = "󰒡 内部 (Inside)"; }

          # [Motions - Lines & Words]
          { __unkeyed-1 = "0"; desc = "跳转至行首"; }
          { __unkeyed-1 = "^"; desc = "跳转至行首(非空字符)"; }
          { __unkeyed-1 = "$"; desc = "跳转至行尾"; }
          { __unkeyed-1 = "w"; desc = "下个单词首"; }
          { __unkeyed-1 = "W"; desc = "下个大写单词首"; }
          { __unkeyed-1 = "b"; desc = "上个单词首"; }
          { __unkeyed-1 = "B"; desc = "上个大写单词首"; }
          { __unkeyed-1 = "e"; desc = "下个单词尾"; }
          { __unkeyed-1 = "E"; desc = "下个大写单词尾"; }

          # [Motions - Char search]
          { __unkeyed-1 = "f"; desc = "向后查找并跳转"; }
          { __unkeyed-1 = "F"; desc = "向前查找并跳转"; }
          { __unkeyed-1 = "t"; desc = "向后查找并跳转至前"; }
          { __unkeyed-1 = "T"; desc = "向前查找并跳转至后"; }
          { __unkeyed-1 = ";"; desc = "重复上次字符查找"; }
          { __unkeyed-1 = ","; desc = "反向重复上次字符查找"; }

          # [Motions - Others]
          { __unkeyed-1 = "G"; desc = "跳转至文件末尾"; }
          { __unkeyed-1 = "%"; desc = "跳转至匹配的括号"; }
          { __unkeyed-1 = "{"; desc = "上一个空行"; }
          { __unkeyed-1 = "}"; desc = "下一个空行"; }

          # [Common g motions]
          { __unkeyed-1 = "ge"; desc = "跳转到上个词尾"; }
          { __unkeyed-1 = "gf"; desc = "打开光标下的文件"; }
          { __unkeyed-1 = "gg"; desc = "跳转到文件首行"; }
          { __unkeyed-1 = "gi"; desc = "跳转到上次插入位置"; }
          { __unkeyed-1 = "gn"; desc = "搜索并选中"; }
          { __unkeyed-1 = "gv"; desc = "选中上次可视区域"; }
          { __unkeyed-1 = "gw"; desc = "格式化当前行"; }
          { __unkeyed-1 = "gx"; desc = "调用系统默认程序打开"; }
          { __unkeyed-1 = "r"; desc = "虚拟替换"; }
          { __unkeyed-1 = "s"; desc = "Flash 搜索"; }
          { __unkeyed-1 = "S"; desc = "Flash Treesitter"; }
          { __unkeyed-1 = "~"; desc = "切换大小写"; }
          { __unkeyed-1 = "?"; desc = "向后搜索"; }
          { __unkeyed-1 = "<A-n>"; desc = "跳转至下一个引用"; }
          { __unkeyed-1 = "<A-p>"; desc = "跳转至上一个引用"; }
          { __unkeyed-1 = "<Esc>"; desc = "清除搜索高亮"; }
        ];
      };
    };
  };

  programs.nixvim.keymaps = [
    { mode = [ "n" "x" "o" ]; key = "s"; action = "<cmd>lua require('flash').jump()<cr>"; options.desc = "Flash 搜索"; }
    { mode = [ "n" "o" ]; key = "S"; action = "<cmd>lua require('flash').treesitter()<cr>"; options.desc = "Flash Treesitter"; }
    { mode = "o"; key = "r"; action = "<cmd>lua require('flash').remote()<cr>"; options.desc = "远程 Flash"; }
    { mode = [ "o" "x" ]; key = "R"; action = "<cmd>lua require('flash').treesitter_search()<cr>"; options.desc = "Treesitter 搜索"; }
    { mode = "c"; key = "<C-s>"; action = "<cmd>lua require('flash').toggle()<cr>"; options.desc = "切换 Flash 搜索"; }
  ];
}
