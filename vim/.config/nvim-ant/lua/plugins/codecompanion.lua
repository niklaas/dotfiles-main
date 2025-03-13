local function api_key(filename)
  return "cmd: gpg --batch --quiet --decrypt " .. vim.fn.stdpath("config") .. "/secrets/" .. filename
end

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },
  config = true,
  cmd = { "CodeCompanion", "CodeCompanionChat" },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "CodeCompanionChat" },
    { "<leader>c<space>", ":CodeCompanion /buffer ", desc = "CodeCompanion buffer" },
  },
  opts = {
    window = {
      position = "right",
    },
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              default = "codestral:latest",
            },
          },
        })
      end,
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = api_key("anthropic.gpg"),
          },
          schema = {
            model = {
              default = "claude-3-5-sonnet-20241022",
            },
          },
        })
      end,
      mistral = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "mistral",
          env = {
            url = "https://api.mistral.ai",
            api_key = api_key("mistral-ai.gpg"),
            chat_url = "/v1/chat/completions",
          },
          handlers = {
            form_parameters = function(_, params, _)
              params.stream_options = nil
              params.options = nil

              return params
            end,
          },
          schema = {
            temperature = {
              default = 0.2,
              mapping = "parameters", -- not supported in default parameters.options
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "ollama",
      },
    },
  },
}
