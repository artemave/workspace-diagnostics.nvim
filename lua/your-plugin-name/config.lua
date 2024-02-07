local YourPluginName = {}

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
YourPluginName.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
}

--- Define your your-plugin-name setup.
---
---@param options table Module config table. See |YourPluginName.options|.
---
---@usage `require("your-plugin-name").setup()` (add `{}` with your |YourPluginName.options| table)
function YourPluginName.setup(options)
    options = options or {}

    YourPluginName.options = vim.tbl_deep_extend("keep", options, YourPluginName.options)

    return YourPluginName.options
end

return YourPluginName
