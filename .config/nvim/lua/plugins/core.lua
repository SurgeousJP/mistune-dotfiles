-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
return {
  -- =========================
  -- Colorscheme
  -- =========================
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd.colorscheme("tokyodark")
    end,
  },

  -- =========================
  -- Symbols Outline
  -- =========================
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
    config = true,
  },

  -- =========================
  -- Telescope (Windows-safe, no fzf-native)
  -- =========================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup()
    end,
  },

  -- =========================
  -- Treesitter
  -- =========================
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    opts = {
      ensure_installed = {
        "bash",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "rust",
        "css",
        "vue",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      -- require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- =========================
  -- Mason
  -- =========================
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "nxls",
      },
    },
  },

  -- =========================
  -- LuaSnip (disable default keymaps)
  -- =========================
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
}
