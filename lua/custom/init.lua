require("custom.commands")
require("custom.remaps")
require("custom.plugins")

local ok, file = pcall(io.open, vim.fn.stdpath("config") .. "/lua/custom/config/theme.conf", "r")
if ok and file then
  local savedTheme = file:read("*l")
  file:close()
  if savedTheme and savedTheme ~= "" then
    vim.cmd("colorscheme " .. savedTheme)
  end
else
  print("theme configuration has not been found!")
end
