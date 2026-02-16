return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.9,
      smear_between_buffers = false,
      trailing_stiffness = 0.8,
      distance_stop_animating = 0.3,
    },
    config = function(_, opts)
      require("smear_cursor").setup(opts)

      -- VS Code Neovim needs faster updates for smooth animation
      if vim.g.vscode then
        vim.opt.updatetime = 10
      end
    end,
  },
}
