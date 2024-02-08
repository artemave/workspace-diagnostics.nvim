local M = {}
local _loaded_clients = {}
local _workspace_files

--- Plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
M.options = {
  workspace_files = function()
    return vim.fn.split(vim.fn.system("git ls-files"), "\n")
  end,

  debug = false,
}

--- Define workspace-diagnostics setup.
---
---@param options table Module config table. See |WorkspaceDiagnostics.options|.
---
---@usage `require("workspace-diagnostics").setup()` (add `{}` with your |WorkspaceDiagnostics.options| table)
function M.setup(options)
  options = options or {}

  M.options = vim.tbl_deep_extend("keep", options, M.options)

  return M.options
end

local function _get_workspace_files()
  if _workspace_files == nil then
    _workspace_files = M.options.workspace_files()

    _workspace_files = map(_workspace_files, function(_, path)
      return vim.fn.fnamemodify(path, ":p")
    end)
  end

  return _workspace_files
end

local _registry = {}

local function _set_loaded_for_client(path, client)
  if _registry[path] == nil then
    _registry[path] = { client }
  else
    table.insert(_registry[path], client)
  end
end

local function _is_client_loaded(client)
  for _, clients in ipairs(_registry) do
    if vim.tbl_contains(clients, client) then
      return true
    end
  end

  return false
end

local function _loaded_clients_for_path(path)
  return _registry[path] or {}
end

--- Populate workspace diagnostics.
---
---@param client table Lsp client.
---@param bufnr number Buffer number.
---
---@usage `require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)`
function M.populate_workspace_diagnostics(client, bufnr)
  if _is_client_loaded(client) then
    return
  end

  if not vim.tbl_get(client.server_capabilities, "textDocumentSync", "openClose") then
    return
  end

  local workspace_files = _get_workspace_files()

  for _, path in ipairs(workspace_files) do
    if path == vim.api.nvim_buf_get_name(bufnr) then
      goto continue
    end

    local filetype = vim.filetype.match({ filename = path })

    if not vim.tbl_contains(client.config.filetypes, filetype) then
      goto continue
    end

    local params = {
      textDocument = {
        uri = vim.uri_from_fname(path),
        version = 0,
        text = vim.fn.join(vim.fn.readfile(path), "\n"),
        languageId = filetype,
      },
    }
    client.notify("textDocument/didOpen", params)
    _set_loaded_for_client(path, client)

    ::continue::
  end
end

function M.ensure_textDocument_didClose(path)
  for _, client in ipairs(_loaded_clients_for_path(path)) do
    local params = {
      textDocument = {
        uri = vim.uri_from_fname(path),
      },
    }
    client.notify("textDocument/didClose", params)
  end
end

return M
