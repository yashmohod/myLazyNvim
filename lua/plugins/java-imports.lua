return {
  -- We attach behavior when an LSP client attaches (jdtls included)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Keymap (manual)
      vim.keymap.set("n", "<leader>co", function()
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.organizeImports" } },
        })
      end, { desc = "Organize Imports (LSP)" })

      -- Auto organize imports on save for Java
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.java",
        callback = function()
          -- only do it if jdtls is attached
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          local has_jdtls = false
          for _, c in ipairs(clients) do
            if c.name == "jdtls" then
              has_jdtls = true
              break
            end
          end
          if not has_jdtls then
            return
          end

          pcall(function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source.organizeImports" } },
            })
          end)
        end,
      })
    end,
  },
}
