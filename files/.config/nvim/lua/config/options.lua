local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.autoread = true
opt.hidden = true
opt.showcmd = true

opt.number = true
opt.cursorline = true
opt.virtualedit = "onemore"
opt.smartindent = true
opt.showmatch = true
opt.laststatus = 3
opt.wildmode = { "list", "longest" }
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 4

opt.list = true
opt.listchars = { tab = "▸-" }
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.wrapscan = true

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto_comment_off", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})
