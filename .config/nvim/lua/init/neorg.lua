
require('neorg').setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.completion"] = { 
      config = {
        engine = "nvim-cmp",
        name = "[Norg]" 
      } 
    },
    ["core.concealer"] = { -- Adds pretty icons to your documents
      config = {
        icon_preset = 'diamond',
        icons = {
          todo = {
            done = {
              icon = "✓",
            },
            pending = {
              icon = "◌",
            },
            undone = {
              icon = " ",
            },
          },
        },
      }
    },
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace = "notes",
      },
    },
    ["core.summary"] = {},
    ["core.export"] = {},
    ["core.esupports.metagen"] = {
      config = {
        type = "auto",
        template = {
          -- The title field generates a title for the file based on the filename.
          { "title", },

          -- The description field is always kept empty for the user to fill in.
          { "description", },

          -- The authors field is autopopulated by querying the current user's system username.
          { "authors", },

          -- The categories field is always kept empty for the user to fill in.
          { "categories", "[]" },

          -- The created field is populated with the current date as returned by `os.date`.
          { "created", },

          -- When creating fresh, new metadata, the updated field is populated the same way
          -- as the `created` date.
          { "updated", },

          -- The version field determines which Norg version was used when
          -- the file was created.
          { "version", },
        },
      },
    },
  },
}
vim.cmd.command("Todo :edit ~/notes/Todos.norg")
vim.cmd.command("Index :Neorg index")
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.norg"},
  command = "set conceallevel=3"
})
