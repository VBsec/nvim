return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}
      
      -- Configure clangd for Zephyr projects
      opts.servers.clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        root_dir = function(fname)
          local util = require("lspconfig.util")
          -- Look for Zephyr project markers
          return util.root_pattern(
            "west.yml",
            "CMakeLists.txt",
            ".west",
            "zephyr",
            ".git"
          )(fname)
        end,
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      }

      -- Add support for devicetree files
      if vim.fn.executable("zephyr-ide") == 1 then
        opts.servers.zephyr_ide = {
          cmd = { "zephyr-ide", "lsp" },
          filetypes = { "dts", "overlay" },
        }
      end

      return opts
    end,
  },
  
  -- Syntax highlighting for Kconfig files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cmake",
        "devicetree",
        "kconfig",
        "python",
        "yaml",
      })
      return opts
    end,
  },

  -- DAP configuration for debugging with J-Link/SEGGER
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "codelldb" })
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      
      -- GDB configuration for Zephyr debugging
      dap.adapters.arm_gdb = {
        type = "executable",
        command = "arm-none-eabi-gdb",
        args = { "-i", "dap" },
      }

      dap.configurations.c = dap.configurations.c or {}
      table.insert(dap.configurations.c, {
        name = "Debug Zephyr (J-Link)",
        type = "arm_gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to zephyr.elf: ", vim.fn.getcwd() .. "/apps/iot-connector/build/zephyr/zephyr.elf", "file")
        end,
        cwd = "${workspaceFolder}",
        setupCommands = {
          {
            text = "target remote :2331",
            description = "Connect to J-Link GDB Server",
            ignoreFailures = false,
          },
          {
            text = "monitor reset",
            description = "Reset target",
            ignoreFailures = false,
          },
          {
            text = "load",
            description = "Load program",
            ignoreFailures = false,
          },
        },
      })
    end,
  },

  -- Quick compile error navigation
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        west_build = {
          mode = "quickfix",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
      },
    },
    keys = {
      { "<leader>xw", "<cmd>Trouble west_build toggle<cr>", desc = "West Build Errors (Trouble)" },
    },
  },
}