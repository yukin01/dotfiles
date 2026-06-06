local map = vim.keymap.set

map("n", "j", "gj")
map("n", "k", "gk")

map("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true })
