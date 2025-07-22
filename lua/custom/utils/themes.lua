local themes = vim.fn.getcompletion('', 'color')

function Theme_apply(theme)
  if theme and theme ~= '' then
    vim.cmd('colorscheme ' .. theme)

    -- Save to /lua/custom/theme.conf
    local file = io.open(vim.fn.stdpath 'config' .. '/lua/custom/config/theme.conf', 'w')
    if file then
      file:write(theme)
      file:close()
    end

    vim.notify('Theme: ' .. (vim.g.colors_name or theme), vim.log.levels.INFO)
  end
end

function Theme_switcher()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Switch Theme',
      finder = finders.new_table { results = themes },
      sorter = conf.generic_sorter {},
      attach_mappings = function(_, map)
        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            Theme_apply(selection[1])
          else
            vim.notify('No theme selected', vim.log.levels.WARN)
          end
        end)
        return true
      end,
    })
    :find()
end

return { Switcher, Apply }
