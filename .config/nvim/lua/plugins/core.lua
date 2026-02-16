-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim

-- =========================
-- Performance Optimizations - File Exclusions
-- =========================
vim.opt.wildignore:append({
  -- Version Control
  "*.git/*", ".git\\*", ".svn/*", ".hg/*",
  
  -- Dependencies & Build
  "*/node_modules/*", "node_modules\\*",
  "*/bin/*", "bin\\*", "*/obj/*", "obj\\*",
  "*/target/*", "*/build/*", "*/dist/*", "*/out/*",
  "*/vendor/*", "*/.nuget/*", "*/packages/*",
  
  -- IDE & Editor
  "*/.vs/*", ".vs\\*", "*/.vscode/*", "*/.idea/*",
  "*.suo", "*.user", "*.userosscache", "*.sln.docstates",
  
  -- Compiled & Binary
  "*.exe", "*.dll", "*.so", "*.dylib", "*.a", "*.lib",
  "*.o", "*.obj", "*.pdb", "*.class", "*.jar", "*.war",
  "*.pyc", "*/__pycache__/*",
  
  -- Logs & Temp
  "*.log", "*.tmp", "*.temp", "*.swp", "*.swo", 
  "*.DS_Store", "Thumbs.db",
  
  -- Media & Archives
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.ico",
  "*.mp3", "*.mp4", "*.avi", "*.mov", "*.wmv",
  "*.pdf", "*.zip", "*.tar", "*.gz", "*.7z", "*.rar",
})

-- Prevent certain files from being opened as buffers
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {
    "*.min.js", "*.min.css", -- Minified files
    "package-lock.json", "yarn.lock", "pnpm-lock.yaml", -- Lock files
    "*.map", -- Source maps
    "*.d.ts", -- TypeScript declaration files (read-only)
  },
  callback = function(args)
    -- Set buffer as read-only and don't track changes
    vim.bo[args.buf].readonly = true
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].swapfile = false
    vim.bo[args.buf].undofile = false
    vim.bo[args.buf].backup = false
    vim.bo[args.buf].writebackup = false
    
    -- Disable LSP for these files
    vim.b[args.buf].autoformat = false
    
    -- Show notification for large/excluded files
    local filename = vim.fn.expand("%:t")
    if vim.fn.match(filename, '\\.min\\.') >= 0 then
      vim.notify("Opened minified file (read-only): " .. filename, vim.log.levels.INFO)
    end
  end,
})

-- Exclude large files from loading completely
vim.api.nvim_create_autocmd({"BufReadPre"}, {
  callback = function(args)
    local file = args.file
    if file == "" then return end
    
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, file)
    
    if ok and stats and stats.size > max_filesize then
      vim.notify(string.format("File too large (%dMB), opening with limited features", math.floor(stats.size / 1024 / 1024)), vim.log.levels.WARN)
      
      -- Disable heavy features for large files
      vim.b[args.buf].large_file = true
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false
      vim.bo[args.buf].backup = false
      vim.bo[args.buf].writebackup = false
      vim.bo[args.buf].syntax = ""
      vim.b[args.buf].autoformat = false
      
      -- Disable treesitter
      vim.cmd("TSBufDisable highlight")
      vim.cmd("TSBufDisable indent")
      
      -- Disable LSP
      vim.cmd("LspStop")
    end
  end,
})

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
            -- Version Control
            "%.git/",
            "%.git\\",
            "%.gitignore",
            "%.gitmodules",
            "%.svn/",
            "%.hg/",
            
            -- Dependencies & Package Managers
            "node_modules/",
            "node_modules\\",
            "package%-lock%.json",
            "yarn%.lock",
            "pnpm%-lock%.yaml",
            "vendor/",
            "Godeps/",
            "%.nuget/",
            "packages/",
            
            -- Build Outputs
            "target/",
            "build/",
            "dist/",
            "out/",
            "bin/",
            "bin\\",
            "obj/",
            "obj\\",
            "%.o",
            "%.a",
            "%.so",
            "%.dylib",
            "%.dll",
            "%.exe",
            "%.pdb",
            "%.class",
            "%.jar",
            "%.war",
            "%.pyc",
            "__pycache__/",
            "%.cache/",
            
            -- IDE & Editor
            "%.vs/",
            "%.vs\\",
            "%.vscode/",
            "%.idea/",
            "%.eclipse/",
            "%.settings/",
            "%.project",
            "%.classpath",
            "%.suo",
            "%.user",
            "%.userosscache",
            "%.sln%.docstates",
            
            -- Logs & Temp
            "%.log",
            "%.tmp",
            "%.temp",
            "%.swp",
            "%.swo",
            "%.DS_Store",
            "Thumbs%.db",
            
            -- Database & Cache
            "%.db",
            "%.sqlite",
            "%.sqlite3",
            
            -- Media Files (usually not edited)
            "%.jpg", "%.jpeg", "%.png", "%.gif", "%.bmp", "%.ico",
            "%.mp3", "%.mp4", "%.avi", "%.mov", "%.wmv",
            "%.pdf", "%.doc", "%.docx", "%.xls", "%.xlsx",
            
            -- Archives
            "%.zip", "%.tar", "%.gz", "%.7z", "%.rar",
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
