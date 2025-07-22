-- Tools
local map = vim.keymap.set

-- Resets

-- General
map('v', '<leader>w', function()
  local keys = vim.api.nvim_replace_termcodes('vbvel', true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end, { desc = 'Select word with extra char' })

map('v', '<leader>"', function()
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  vim.cmd 'normal! `<i"'
  vim.cmd 'normal! `>a"'
end, { desc = 'Wrap in double quotes' })

map('v', "<leader>'", function()
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  vim.cmd "normal! `<i'"
  vim.cmd "normal! `>a'"
end, { desc = 'Wrap in double quotes' })

-- autocompletion fix to legacy

-- Telescope
local telescopeBuiltin = require 'telescope.builtin'

map('n', '<leader>pf', telescopeBuiltin.find_files, { desc = '[P]roject [F]iles' })
map('n', '<C-p>', telescopeBuiltin.git_files, { desc = 'Git Files (<C-p>)' })
map('n', '<leader>ps', function()
  telescopeBuiltin.grep_string { search = vim.fn.input 'Grep > ' }
end, { desc = '[P]roject [S]earch (input)' })

require 'custom.utils.themes'
map('n', '<leader>tt', Theme_switcher, { desc = 'Telescope: Theme Switcher' })

-- navigation
local harpoon = require 'harpoon'
harpoon:setup()

map('n', '<leader>aa', function()
  harpoon:list():add()
end, { desc = 'Harpoon add file in the list' })

map('n', '<leader>1', function()
  harpoon:list():select(1)
end)
map('n', '<leader>2', function()
  harpoon:list():select(2)
end)
map('n', '<leader>3', function()
  harpoon:list():select(3)
end)
map('n', '<leader>4', function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
map('n', '<leader>q', function()
  harpoon:list():prev()
end)
map('n', '<leader>e', function()
  harpoon:list():next()
end)

-- basic telescope configuration
local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

map('n', '<C-e>', function()
  toggle_telescope(harpoon:list())
end, { desc = 'Open harpoon window' })

-- Text manipulations
map('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'move selected lines down' })
map('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'move selected lines up' })
