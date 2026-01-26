return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  },
  opts = function(_, opts)
    -- Ensure formatting table exists
    opts.formatting = opts.formatting or {}
    local format_kinds = opts.formatting.format
    opts.formatting.format = function(entry, item)
      if format_kinds then
        format_kinds(entry, item)
      end
      return require("tailwindcss-colorizer-cmp").formatter(entry, item)
    end
  end,
}
