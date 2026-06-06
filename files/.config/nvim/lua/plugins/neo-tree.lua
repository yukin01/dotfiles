return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<CR>",  desc = "Focus file explorer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local argc = vim.fn.argc()
          local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
          if argc == 0 or is_dir then
            vim.schedule(function()
              vim.cmd("Neotree show")
            end)
          end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      default_component_configs = {
        indent = { with_markers = true, with_expanders = true },
        git_status = {
          symbols = {
            added = "+",
            modified = "~",
            deleted = "-",
            renamed = "→",
            untracked = "?",
            ignored = "i",
            unstaged = "u",
            staged = "s",
            conflict = "!",
          },
        },
      },
    },
  },
}
