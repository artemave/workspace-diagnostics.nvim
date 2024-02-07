-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.YourPluginNameLoaded then
    return
end

_G.YourPluginNameLoaded = true

vim.api.nvim_create_user_command("YourPluginName", function()
    require("your-plugin-name").toggle()
end, {})
