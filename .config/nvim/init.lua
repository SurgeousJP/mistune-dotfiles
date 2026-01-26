-- Fast startup
if vim.loader then
vim.loader.enable()
end

-- Load core config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins
require("config.lazy")