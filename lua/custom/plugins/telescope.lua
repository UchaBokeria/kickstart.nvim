---@diagnostic disable: different-requires
local is_vscode = vim.g.vscode == 1

-- Only return telescope configuration if not in VSCode
if is_vscode then
  return {}
end

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      -- Core dependencies
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',

      -- 🔍 File Browser with better UI
      { 'nvim-telescope/telescope-file-browser.nvim' },

      -- ⚡ FZF-native sorter for better performance
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

      -- 🧠 Undo tree visualization
      { 'debugloop/telescope-undo.nvim' },

      -- 🗂 Project management
      { 'nvim-telescope/telescope-project.nvim' },

      -- 🌲 Git worktree integration
      { 'ThePrimeagen/git-worktree.nvim' },

      -- 📂 Directory jumping with zoxide
      { 'jvgrootveld/telescope-zoxide' },

      -- 🔖 Browser bookmarks integration
      { 'dhruvmanila/telescope-bookmarks.nvim' },

      -- 🖼 Media files preview
      { 'nvim-telescope/telescope-media-files.nvim' },

      -- 🐙 GitHub issues and PRs
      { 
        'pwntester/octo.nvim',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-tree/nvim-web-devicons'
        },
        config = function()
          require("octo").setup({
            enable_builtin = true,
            default_remote = {"upstream", "origin"},
            ssh_aliases = {},
            reaction_viewer_hint_icon = "",
            picker_config = {
              mappings = {
                -- Change from string to table format
                open_in_browser = {
                  lhs = "<C-b>",
                  desc = "open issue in browser"
                },
                copy_url = {
                  lhs = "<C-y>",
                  desc = "copy url to system clipboard"
                },
                checkout_pr = {
                  lhs = "<C-o>",
                  desc = "checkout pull request"
                },
              },
            },
            ui = {
              use_signcolumn = true,  -- show "modified" marks on the sign column
            },
            repo = {
              order_by = {
                field = "CREATED_AT",
                direction = "DESC"
              }
            },
            git_worktree = {
              order_by = {
                field = "CREATED_AT",
                direction = "DESC"
              }
            },
            issues = {
              order_by = {
                -- criteria to sort results of `Octo issue list`
                field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT
                direction = "DESC"    -- either DESC or ASC
              }
            },
            pull_requests = {
              order_by = {
                -- criteria to sort the results of `Octo pr list`
                field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT
                direction = "DESC"    -- either DESC or ASC
              }
            },
            file_panel = {
              size = 10,      -- changed files panel rows
              use_icons = true -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
            },
          })
        end
      },

      -- 📍 Git repo listing
      { 'cljoly/telescope-repo.nvim' },

      -- 📄 Markdown/Org heading search
      { 'crispgm/telescope-heading.nvim' },

      -- 🔎 Advanced live grep with args
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },

    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local fb_actions = require('telescope').extensions.file_browser.actions

      telescope.setup({
        defaults = {
          -- Default configuration for telescope goes here:
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
          },
        },
        extensions = {
          -- File browser configuration
          file_browser = {
            -- hijack_netrw = true,
            mappings = {
              i = {
                ["<C-w>"] = function() vim.cmd('normal vbd') end,
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-l>"] = actions.select_default,
              },
              n = {
                ["h"] = fb_actions.goto_parent_dir,
                ["l"] = actions.select_default,
                ["/"] = function()
                  vim.cmd('startinsert')
                end
              },
            },
          },
          -- Project management configuration
          project = {
            base_dirs = (function()
              local paths = {}
              
              -- Get home directory
              local home = vim.fn.expand('$HOME')
              
              -- Common project directories to check
              local possible_paths = {
                "/var/www",
                home .. "/toolkits",
                home .. "/Projects",
                home .. "/projects",
                home .. "/dev",
                home .. "/Development",
                home .. "/workspace",
                home .. "/work",
                home .. "/.config",  -- For dotfiles
                vim.fn.getcwd(),     -- Current working directory
              }

              -- Add paths that exist and are accessible
              for _, path in ipairs(possible_paths) do
                if vim.fn.isdirectory(path) == 1 then
                  table.insert(paths, { path = path, max_depth = 5 })
                end
              end

              -- If no paths are found, use current directory
              if #paths == 0 then
                paths = { { path = vim.fn.getcwd(), max_depth = 3 } }
              end

              return paths
            end)(),
            hidden_files = true,
            theme = "dropdown",
            order_by = "recent",
            search_by = "title",
            sync_with_nvim_tree = true,
            -- Auto-detect git repositories
            on_project_selected = function(prompt_bufnr)
              local project_actions = require("telescope._extensions.project.actions")
              project_actions.change_working_directory(prompt_bufnr, false)
            end,
          },
          -- Media files configuration
          media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
            find_cmd = "rg",
          },
          -- Live grep args configuration
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
          -- Heading search configuration
          heading = {
            theme = "dropdown",
            treesitter = true,
          },
          -- Repo configuration
          repo = {
            theme = "dropdown",
            list = {
              find_command = "find",
              find_args = {
                "-type", "d",
                "-exec", "test", "-e", "{}/.git", ";",
                "-print", "-prune"
              },
              search_dirs = {
                "~/toolkits",
                "/var/www/web",
              },
            },
            settings = {
              auto_lcd = true,
              mappings = {
                i = {
                  ["<C-a>"] = function() vim.cmd("lcd " .. vim.fn.expand("%:p:h")) end,
                },
              },
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })

      -- Setup git-worktree
      require("git-worktree").setup({
        change_directory_command = "cd",  -- default
        update_on_change = true,         -- default
        update_on_change_command = "e .", -- default
        clearjumps_on_change = true,     -- default
        autopush = false,                -- default
      })

      -- Load all extensions
      local extensions = {
        'file_browser',
        'fzf',
        'project',
        'git_worktree',
        'zoxide',
        'bookmarks',
        'media_files',
        'repo',
        'heading',
        'live_grep_args',
        'undo',
      }

      -- Load extensions safely
      for _, ext in ipairs(extensions) do
        pcall(telescope.load_extension, ext)
      end
    end,
  },
}
