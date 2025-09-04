return {
  "ibhagwan/fzf-lua",
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