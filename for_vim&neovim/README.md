# NeoVim setting
- LazyVimを使う  
```git clone https://github.com/LazyVim/starter ~/.config/nvim```  
```rm -rf ~/.config/nvim/.git```  
- start neovim  
```nvim```
  
- colorscheme  
```/.config/nvim/lua/plugins/colorscheme.lua```  
    を編集して、以下を追加する
    ```
    return {
        "craftzdog/solarized-osaka.nvim",
            lazy = true,
            priority = 1000,
            opts = function()
                return {
                    transparent = true,
                }
        end,
    }
    ```
  
    ```/.config/nvim/lua/config/lazy.lua```  
    のrequire(...)のspecの下の行の"add LazyVim and import its plugins"を以下のように変更する  
    ```
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = {
      colorscheme = "solarized-osaka",
    } },

    ```