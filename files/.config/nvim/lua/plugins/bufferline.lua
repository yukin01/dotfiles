return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bd", "<cmd>bdelete<CR>",               desc = "Delete buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",   desc = "Pin buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "slant",
        indicator = { style = "underline" },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        tab_size = 20,
        padding = 1,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },
}
