-- Keys
vim.g.mapleader = " " 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Explorer
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- File Management
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Misc
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.colorcolumn = "80,120"
vim.opt.termguicolors = true

-- Cursor
vim.opt.guicursor = "" -- terminal's default cursor

local betterCursor = vim.api.nvim_create_augroup("betterCursor", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave", "WinEnter" }, {
    group = betterCursor,
    callback = function()
        vim.wo.cursorline = true
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    group = betterCursor,
    callback = function()
        vim.wo.cursorline = false
    end,
})

-- Plugins
vim.pack.add({
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
})

-- Theme
require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")
