return {
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			require("dap-go").setup()

			-- Add custom configuration at the beginning of the list
			local dap = require("dap")
			table.insert(dap.configurations.go, 2, {
				type = "go",
				name = "🚀 Debug server with env",
				request = "launch",
				program = "${workspaceFolder}/cmd/server",
				env = function()
					-- Run infisical to generate .env file
					vim.fn.system({
						"infisical",
						"export",
						"--format=dotenv",
						"--env=dev",
						"--output-file=" .. vim.fn.getcwd() .. "/.env",
					})

					local env = {}
					-- Load .env files
					for _, file in ipairs({ "/.env", "/.env.local" }) do
						local env_file = vim.fn.getcwd() .. file
						if vim.fn.filereadable(env_file) == 1 then
							for line in io.lines(env_file) do
								local key, value = line:match("^([^=]+)=(.*)$")
								if key and value then
									env[key] = value
								end
							end
						end
					end
					env.LOG_LEVEL = "debug"
					return env
				end,
			})
		end,
	},
}
