return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
      
      -- Ensure Copilot starts properly
      vim.defer_fn(function()
        vim.cmd("Copilot auth")
      end, 1000)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    keys = {
      {"<leader>cc", ":CopilotChat<CR>", desc = "CopilotChat - Open Chat" },
      {"<leader>ze", ":CopilotChatExplain<CR>", desc = "CopilotChat - Explain Code" },
      {"<leader>zr", ":CopilotChatReview<CR>", desc = "CopilotChat - Review Code" },
      {"<leader>zf", ":CopilotChatFix<CR>", desc = "CopilotChat - Fix Code Issues" },
      {"<leader>zo", ":CopilotChatOptimize<CR>", desc = "CopilotChat - Optimize Code" },
      {"<leader>zs", ":CopilotChatSuggest<CR>", desc = "CopilotChat - Suggest Improvements" },
      -- Show help actions with telescope
      -- {
      --   "<leader>cch",
      --   function()
      --     local actions = require("CopilotChat.actions")
      --     require("CopilotChat.integrations.telescope").pick(actions.help_actions())
      --   end,
      --   desc = "CopilotChat - Help actions",
      -- },
      -- -- Show prompts actions with telescope
      -- {
      --   "<leader>ccp",
      --   function()
      --     local actions = require("CopilotChat.actions")
      --     require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      --   end,
      --   desc = "CopilotChat - Prompt actions",
      -- },
      -- {
      --   "<leader>cco",
      --   "<cmd>CopilotChatOpen<cr>",
      --   desc = "CopilotChat - Open",
      -- },
      -- {
      --   "<leader>ccq",
      --   function()
      --     local input = vim.fn.input("Quick Chat: ")
      --     if input ~= "" then
      --       require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
      --     end
      --   end,
      --   desc = "CopilotChat - Quick question",
      -- },
      -- -- Chat with Copilot in visual mode
      -- {
      --   "<leader>ccv",
      --   ":CopilotChatVisual",
      --   mode = "x",
      --   desc = "CopilotChat - Open in vertical split",
      -- },
      -- {
      --   "<leader>ccx",
      --   ":CopilotChatInPlace<cr>",
      --   mode = "x",
      --   desc = "CopilotChat - Run in-place code",
      -- },
    },
  },
}