-- partially imported from https://github.com/echasnovski/mini.nvim
local Helpers = {}

-- Add extra expectations
Helpers.expect = vim.deepcopy(MiniTest.expect)

-- The error message returned when a test fails.
local function errorMessage(str, pattern)
    return string.format("Pattern: %s\nObserved string: %s", vim.inspect(pattern), str)
end

-- Check equality of a global `field` against `value` in the given `child` process.
-- @usage global_equality(child, "_G.YourPluginNameLoaded", true)
Helpers.expect.global_equality = MiniTest.new_expectation(
    "variable in child process matches",
    function(child, field, value)
        return Helpers.expect.equality(child.lua_get(field), value)
    end,
    errorMessage
)

-- Check type equality of a global `field` against `value` in the given `child` process.
-- @usage global_type_equality(child, "_G.YourPluginNameLoaded", "boolean")
Helpers.expect.global_type_equality = MiniTest.new_expectation(
    "variable type in child process matches",
    function(child, field, value)
        return Helpers.expect.global_equality(child, "type(" .. field .. ")", value)
    end,
    errorMessage
)

-- Check equality of a config `field` against `value` in the given `child` process.
-- @usage option_equality(child, "debug", true)
Helpers.expect.config_equality = MiniTest.new_expectation(
    "config option matches",
    function(child, field, value)
        return Helpers.expect.global_equality(child, "_G.YourPluginName.config." .. field, value)
    end,
    errorMessage
)

-- Check type equality of a config `field` against `value` in the given `child` process.
-- @usage config_type_equality(child, "debug", "boolean")
Helpers.expect.config_type_equality = MiniTest.new_expectation(
    "config option type matches",
    function(child, field, value)
        return Helpers.expect.global_equality(
            child,
            "type(_G.YourPluginName.config." .. field .. ")",
            value
        )
    end,
    errorMessage
)

-- Check equality of a state `field` against `value` in the given `child` process.
-- @usage state_equality(child, "enabled", true)
Helpers.expect.state_equality = MiniTest.new_expectation(
    "state matches",
    function(child, field, value)
        return Helpers.expect.global_equality(child, "_G.YourPluginName.enabled." .. field, value)
    end,
    errorMessage
)

-- Check type equality of a state `field` against `value` in the given `child` process.
-- @usage state_type_equality(child, "enabled", "boolean")
Helpers.expect.state_type_equality = MiniTest.new_expectation(
    "state type matches",
    function(child, field, value)
        return Helpers.expect.global_equality(
            child,
            "type(_G.YourPluginName.state." .. field .. ")",
            value
        )
    end,
    errorMessage
)

Helpers.expect.match = MiniTest.new_expectation("string matching", function(str, pattern)
    return str:find(pattern) ~= nil
end, errorMessage)

Helpers.expect.no_match = MiniTest.new_expectation("no string matching", function(str, pattern)
    return str:find(pattern) == nil
end, errorMessage)

-- Monkey-patch `MiniTest.new_child_neovim` with helpful wrappers
Helpers.new_child_neovim = function()
    local child = MiniTest.new_child_neovim()

    local prevent_hanging = function(method)
    -- stylua: ignore
    if not child.is_blocked() then return end

        local msg =
            string.format("Can not use `child.%s` because child process is blocked.", method)
        error(msg)
    end

    child.setup = function()
        child.restart({ "-u", "scripts/minimal_init.lua" })

        -- Change initial buffer to be readonly. This not only increases execution
        -- speed, but more closely resembles manually opened Neovim.
        child.bo.readonly = false
    end

    child.set_lines = function(arr, start, finish)
        prevent_hanging("set_lines")

        if type(arr) == "string" then
            arr = vim.split(arr, "\n")
        end

        child.api.nvim_buf_set_lines(0, start or 0, finish or -1, false, arr)
    end

    child.get_lines = function(start, finish)
        prevent_hanging("get_lines")

        return child.api.nvim_buf_get_lines(0, start or 0, finish or -1, false)
    end

    child.set_cursor = function(line, column, win_id)
        prevent_hanging("set_cursor")

        child.api.nvim_win_set_cursor(win_id or 0, { line, column })
    end

    child.get_cursor = function(win_id)
        prevent_hanging("get_cursor")

        return child.api.nvim_win_get_cursor(win_id or 0)
    end

    child.set_size = function(lines, columns)
        prevent_hanging("set_size")

        if type(lines) == "number" then
            child.o.lines = lines
        end

        if type(columns) == "number" then
            child.o.columns = columns
        end
    end

    child.get_size = function()
        prevent_hanging("get_size")

        return { child.o.lines, child.o.columns }
    end

    child.expect_screenshot = function(opts, path, screenshot_opts)
        if child.fn.has("nvim-0.8") == 0 then
            MiniTest.skip("Screenshots are tested for Neovim>=0.8 (for simplicity).")
        end

        MiniTest.expect.reference_screenshot(child.get_screenshot(screenshot_opts), path, opts)
    end

    return child
end

return Helpers
