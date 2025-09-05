return {
  "echasnovski/mini.ai",
  opts = function(_, opts)
    local ai = require("mini.ai")
    
    -- Disable tags textobject
    opts.custom_textobjects = opts.custom_textobjects or {}
    opts.custom_textobjects["t"] = false
    
    -- Add proper argument textobject
    opts.custom_textobjects["a"] = ai.gen_spec.argument()
    
    return opts
  end,
}
