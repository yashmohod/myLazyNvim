return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    {
      "mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "prettierd",
          "prettier",
          "ruff",
          "black",
          "google-java-format",
          "goimports",
        })
      end,
    },
  },

  init = function()
    vim.keymap.set("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports" } },
      })
    end, { desc = "Organize Imports (LSP)" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.java",
      callback = function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if not clients or #clients == 0 then
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

  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ timeout_ms = 3000, lsp_format = "fallback" })
      end,
      mode = { "n", "x" },
      desc = "Format Buffer (Conform)",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },

  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },

    format_on_save = function(_bufnr)
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,

    formatters_by_ft = {
      lua = { "stylua" },
      fish = { "fish_indent" },
      sh = { "shfmt" },

      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },

      python = { "ruff_format", "black" },
      go = { "goimports", "gofmt" },
      java = { "google-java-format" },
    },

    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  },
}
