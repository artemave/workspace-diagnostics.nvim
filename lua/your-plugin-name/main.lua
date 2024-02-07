local D = require("your-plugin-name.util.debug")

-- internal methods
local YourPluginName = {}

-- state
local S = {
    -- Boolean determining if the plugin is enabled or not.
    enabled = false,
}

---Toggle the plugin by calling the `enable`/`disable` methods respectively.
---@private
function YourPluginName.toggle()
    if S.enabled then
        return YourPluginName.disable()
    end

    return YourPluginName.enable()
end

---Initializes the plugin.
---@private
function YourPluginName.enable()
    if S.enabled then
        return S
    end

    S.enabled = true

    return S
end

---Disables the plugin and reset the internal state.
---@private
function YourPluginName.disable()
    if not S.enabled then
        return S
    end

    -- reset the state
    S = {
        enabled = false,
    }

    return S
end

return YourPluginName
