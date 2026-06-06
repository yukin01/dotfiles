return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        sections = {
          { section = "header" },
          {
            text = { { "  Global Shortcuts ", hl = "SnacksDashboardSpecial" } },
            padding = 1,
          },
          {
            { icon = " ", key = "<Space>ff", desc = "Find File",     action = ":FzfLua files" },
            { icon = " ", key = "<Space>fg", desc = "Find Text",     action = ":FzfLua live_grep" },
            { icon = " ", key = "<Space>fb", desc = "Buffers",       action = ":FzfLua buffers" },
            { icon = " ", key = "<Space>fr", desc = "Recent Files",  action = ":FzfLua oldfiles" },
            { icon = " ", key = "<Space>o",  desc = "File Explorer", action = ":Neotree focus" },
            { icon = " ", key = "<Space>gg", desc = "LazyGit",       action = ":LazyGit" },
            gap = 1,
            padding = 1,
          },
          {
            text = { { "  Dashboard Only ", hl = "SnacksDashboardSpecial" } },
            padding = 1,
          },
          {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "c", desc = "Config",   action = ":e ~/.config/nvim/init.lua" },
            { icon = "󰒲 ", key = "L", desc = "Lazy",    action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",    action = ":qa" },
            gap = 1,
            padding = 1,
          },
          { section = "startup" },
        },
      },
    },
  },
}
