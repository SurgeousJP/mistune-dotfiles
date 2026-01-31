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
  -- Mini Bufremove
  -- =========================
  {
    "echasnovski/mini.bufremove",
    version = "*",
    config = function()
      require("mini.bufremove").setup()
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
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "%.git",
            "%.git\\",
            "%.git/",
            "%.git\\.*",
            "%.git/.*",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- =========================
  -- Treesitter
  -- =========================
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    opts = {
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
        disable = {},
      },
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
      autotag = {
        enable = true,
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
  -- LuaSnip
  -- =========================
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      
      -- Set up some basic LuaSnip configuration
      luasnip.config.setup({
        history = true,
        delete_check_events = "TextChanged",
        updateevents = "TextChanged,TextChangedI",
      })
      
      -- Load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- =========================
  -- Auto Pairs
  -- =========================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      autopairs.setup({
        check_ts = true, -- treesitter integration
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- Integration with cmp
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- =========================
  -- Auto Tag
  -- =========================
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end,
  },
}
