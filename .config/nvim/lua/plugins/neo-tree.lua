return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- 👈 REQUIRED for icons
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "right",
        mappings = {
          ["J"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[#siblings]:get_id())
          end,
          ["K"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[1]:get_id())
          end,
        },
      },
      sort_function = function(a, b)
        local function is_in_notes_directory(path)
          return path:match("/notes/") or path:match("^notes/")
        end

        local function get_mod_time(path)
          local stat = vim.loop.fs_stat(path)
          return stat and stat.mtime.sec or 0
        end

        if a.type ~= b.type then
          return a.type == "directory"
        end

        local a_in_notes = is_in_notes_directory(a.path)
        local b_in_notes = is_in_notes_directory(b.path)

        if a_in_notes and b_in_notes and a.type ~= "directory" then
          return get_mod_time(a.path) > get_mod_time(b.path)
        end

        local a_name = vim.fn.fnamemodify(a.path, ":t")
        local b_name = vim.fn.fnamemodify(b.path, ":t")
        return a_name < b_name
      end,
    },
  },
}
