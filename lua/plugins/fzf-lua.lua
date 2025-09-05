return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      actions = {
        -- Add Ctrl-y to copy relative path to clipboard
        ["ctrl-y"] = function(selected)
          local entry = selected[1]
          if entry then
            -- Extract the file path from the entry
            local path = require("fzf-lua").path.entry_to_file(entry).path
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path, vim.log.levels.INFO)
          end
        end,
      },
    },
    diagnostics = {
      actions = {
        -- Add Ctrl-y to yank diagnostic message
        ["ctrl-y"] = function(selected)
          local entry = selected[1]
          if entry then
            -- Extract the diagnostic message from the entry
            local msg = entry:match("%d+:%d+:%s*(.*)$") or entry
            vim.fn.setreg("+", msg)
            vim.notify("Copied: " .. msg, vim.log.levels.INFO)
          end
        end,
      },
    },
  },
  keys = {
    -- Override the Neo-tree <leader>fe mapping to find .env files
    {
      "<leader>fe",
      function()
        require("fzf-lua").files({
          prompt = "Env Files> ",
          -- Use --no-ignore to show gitignored files
          raw_cmd = vim.fn.executable("fd") == 1
            and "fd --type f --hidden --no-ignore --follow '\\.env' --exclude .git --exclude node_modules"
            or vim.fn.executable("rg") == 1
            and "rg --files --hidden --no-ignore --follow -g '.env*' -g '!.git' -g '!node_modules'"
            or "find . -type f -name '.env*' 2>/dev/null",
          git_icons = false,
          file_ignore_patterns = {},
        })
      end,
      desc = "Find env files",
    },
  },
}