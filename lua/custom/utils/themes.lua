---@diagnostic disable: redundant-parameter, undefined-global
local themes = vim.fn.getcompletion('', 'color')

-- Load theme from config file
local function load_saved_theme()
  local file = io.open(vim.fn.stdpath 'config' .. '/lua/custom/config/theme.conf', 'r')
  if file then
    local theme = file:read '*a'
    file:close()
    if theme and theme ~= '' then
      return theme
    end
  end
  return nil
end

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

-- Initialize theme on startup
local function init()
  local saved_theme = load_saved_theme()
  if saved_theme then
    Theme_apply(saved_theme)
  end
end

function Theme_switcher()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local previewers = require 'telescope.previewers'

  -- Get current theme
  local current_theme = vim.g.colors_name or ''
  local initial_theme = current_theme

  -- Create sorted theme list with current theme first
  local theme_entries = {}
  
  -- First add the current theme if it exists
  if current_theme and current_theme ~= '' then
    table.insert(theme_entries, { current_theme .. ' 󰄬', current_theme })
  end

  -- Then add all other themes
  for _, theme in ipairs(themes) do
    if theme ~= current_theme then
      table.insert(theme_entries, { theme, theme })
    end
  end

  -- Create a previewer that shows theme preview
  local theme_previewer = previewers.new_buffer_previewer {
    title = 'Theme Preview',
    define_preview = function(self, entry)
      local bufnr = self.state.bufnr
      local preview_theme = entry.value

      -- Save current theme to restore later
      if not self.state.initial_theme then
        self.state.initial_theme = vim.g.colors_name
      end

      -- Apply theme temporarily
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
          '-- Theme Preview: ' .. preview_theme,
          '',
          'function example(arg)',
          '    local variable = "string"',
          '    if arg > 10 then',
          '        print("Hello, World!")',
          '        return true',
          '    end',
          '    return false',
          'end',
          '',
          '-- Comments look like this',
          '-- Constants: true, false, nil',
          '-- Numbers: 42, 3.14',
          '-- Strings: "quoted text"',
        })

        vim.cmd('colorscheme ' .. preview_theme)
        vim.bo[bufnr].filetype = 'lua'
      end)
    end,
    teardown = function(self)
      -- Restore original theme when closing preview
      if self.state.initial_theme then
        vim.cmd('colorscheme ' .. self.state.initial_theme)
      end
    end,
  }

  pickers
    .new({}, {
      prompt_title = 'Switch Theme',
      finder = finders.new_table {
        results = theme_entries,
        entry_maker = function(entry)
          return {
            value = entry[2], -- Original theme name
            display = entry[1], -- Display with marker if current
            ordinal = entry[2], -- For sorting
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = theme_previewer,
      attach_mappings = function(_, map)
        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            Theme_apply(selection.value)
          else
            -- Restore the initial theme if no selection was made
            if initial_theme and initial_theme ~= '' then
              Theme_apply(initial_theme)
            end
            vim.notify('No theme selected', vim.log.levels.WARN)
          end
        end)
        return true
      end,
    })
    :find()
end

-- Initialize theme on startup
init()

return { Theme_switcher = Theme_switcher, Theme_apply = Theme_apply }
