local helpers = dofile("tests/helpers.lua")

-- See https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/test.lua for more documentation

local child = helpers.new_child_neovim()
local eq = helpers.expect.equality

local T = MiniTest.new_set({
  hooks = {
    -- This will be executed before every (even nested) case
    pre_case = function()
      -- Restart child process with custom 'init.lua' script
      child.restart({ "-u", "scripts/minimal_init.lua" })
    end,
    -- This will be executed one after all tests from this set are finished
    post_once = child.stop,
  },
})

T["setup()"] = MiniTest.new_set()

-- A rather meaningless test. Keep it for the reference.
T["setup()"]["public api"] = function()
  eq(
    child.lua_get([[type(require('workspace-diagnostics').populate_workspace_diagnostics)]]),
    "function"
  )
  eq(child.lua_get([[type(require('workspace-diagnostics').setup)]]), "function")
end

return T
