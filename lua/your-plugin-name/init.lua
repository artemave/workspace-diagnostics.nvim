local M = require("your-plugin-name.main")
local YourPluginName = {}

-- Toggle the plugin by calling the `enable`/`disable` methods respectively.
function YourPluginName.toggle()
    -- when the config is not set to the global object, we set it
    if _G.YourPluginName.config == nil then
        _G.YourPluginName.config = require("your-plugin-name.config").options
    end

    _G.YourPluginName.state = M.toggle()
end

-- starts YourPluginName and set internal functions and state.
function YourPluginName.enable()
    if _G.YourPluginName.config == nil then
        _G.YourPluginName.config = require("your-plugin-name.config").options
    end

    local state = M.enable()

    if state ~= nil then
        _G.YourPluginName.state = state
    end

    return state
end

-- disables YourPluginName and reset internal functions and state.
function YourPluginName.disable()
    _G.YourPluginName.state = M.disable()
end

-- setup YourPluginName options and merge them with user provided ones.
function YourPluginName.setup(opts)
    _G.YourPluginName.config = require("your-plugin-name.config").setup(opts)
end

_G.YourPluginName = YourPluginName

return _G.YourPluginName
