return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<CR>",     desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>",   desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>FzfLua resume<CR>",    desc = "Resume" },
    },
    opts = {
      files = {
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        rg_opts = "--color=never --files --hidden --follow -g '!.git/'",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g '!.git/' -e",
      },
    },
  },
}
