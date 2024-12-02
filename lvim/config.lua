-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.plugins = {
    { "folke/tokyonight.nvim" },
    { "sainnhe/sonokai" },
    { "sbdchd/neoformat" },
    { "uloco/bluloco.nvim" },
    { "rktjmp/lush.nvim" },
    --{
    --   "Pocco81/auto-save.nvim",
    --   config = function()
    --       require("auto-save").setup({})
    --   end
    --},
    {
      'sainnhe/everforest',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        -- vim.g.everforest_enable_italic = true
        -- vim.cmd.colorscheme('everforest')
      end,
    },
    {
        "f-person/git-blame.nvim",
        event = "BufRead",
        config = function()
            vim.cmd "highlight default link gitblame SpecialComment"
            vim.g.gitblame_enabled = 1 -- Change the value to 1 here
        end,
    },
    { "rose-pine/neovim", },
    { 'talha-akram/noctis.nvim' },
    {
        "fatih/vim-go",
    },
    {
        "github/copilot.vim",
    },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {
     'wfxr/minimap.vim',
     build = "cargo install --locked code-minimap",
     cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
     config = function ()
       vim.cmd ("let g:minimap_width = 10")
       vim.cmd ("let g:minimap_auto_start = 1")
       vim.cmd ("let g:minimap_auto_start_win_enter = 1")
     end,
    },
    {
     "nvim-pack/nvim-spectre",
     event = "BufRead",
     config = function()
       require("spectre").setup()
     end,
    },
    {
      "ggandor/leap.nvim",
      name = "leap",
      config = function()
        require("leap").add_default_mappings()
      end,
    },
    {
      "mrjones2014/nvim-ts-rainbow",
    },
    { "EdenEast/nightfox.nvim" },
}
lvim.builtin.treesitter.rainbow.enable = true
lvim.colorscheme = "dawnfox"
lvim.keys.normal_mode["<Down>"] = "<C-e>"
lvim.keys.normal_mode["<Up>"] = "<C-y>"
lvim.keys.normal_mode["<A-Up>"] = "{"
lvim.keys.normal_mode["<A-Down>"] = "}"
lvim.keys.normal_mode["<A-h>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<A-b>"] = ":BufferLineCyclePrev<CR>"
vim.opt.timeoutlen = 1000
vim.opt.timeoutlen = 0
vim.wo.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
lvim.format_on_save = false
vim.o.background = "light"
-- vim.opt.guicursor = "n-v-i-c:ver25"
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})


-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldmethod = "expr" -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
vim.opt.foldenable = false -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.
lvim.builtin.which_key.setup.plugins.presets.z = true
-- vim.g.everforest_background = "hard"
