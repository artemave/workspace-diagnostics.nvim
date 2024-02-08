if _G.WorkspaceDiagnosticsLoaded then
  return
end

_G.WorkspaceDiagnosticsLoaded = true

vim.api.nvim_create_autocmd('BufAdd', {
  callback = function(ev)
    if ev.file ~= '' then
      require("workspace-diagnostics").ensure_textDocument_didClose(ev.file)
    end
  end,
})
