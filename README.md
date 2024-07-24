<p align="center">
  <h1 align="center">workspace-diagnostics.nvim</h2>
</p>

<p>
    Populates project-wide lsp diagnostcs, regardless of what files are opened.
</p>
<p> <a href="https://artem.rocks/posts/workspace_diagnostics_nvim">This post</a> goes into details of lsp diagnostics and how this plugin works.</p>

<details>
  <summary>Demo</summary>
  <p> </p>
  <p>Here you can see that even though a single file gets opened, the diagnostics are populated for other files as well.</p>
  <div align="center">


https://github.com/artemave/workspace-diagnostics.nvim/assets/23721/ae32fdc8-a547-4194-ae00-df19c66d2b5f

  </div>
</details>

## 📋 Installation

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>Snippet</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

</td>
<td>

```lua
use {"artemave/workspace-diagnostics.nvim"}
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
Plug "artemave/workspace-diagnostics.nvim"
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
require("lazy").setup({"artemave/workspace-diagnostics.nvim"})
```

</td>
</tr>
</tbody>
</table>
</div>

## ⚡️ Usage

Populate workspace diagnostcs when an lsp client is attached:

```lua
require('lspconfig').tsserver.setup({
  on_attach = function(client, bufnr)
                ...
                require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                ...
              end
})
```

Despite its placement, `populate_workspace_diagnostics` will actually do the work only once per client.

Alternatively, you can trigger it explicitly via a keybinding. E.g., the following code maps `<space>x` to populate workspace diagnostics:

```lua
vim.api.nvim_set_keymap('n', '<space>x', '', {
  noremap = true,
  callback = function()
    for _, client in ipairs(vim.lsp.buf_get_clients()) do
      require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
    end
  end
})
```

Caveat: this only populates diagnostics for the files that share type with the current buffer. E.g., in a rails project, if you run this in a javascript file, you'll get diagnostics for all javascript files, but not ruby files.

## ⚙ Configuration

You can configure a different function that returns a list of project files (it defaults to the output of `git ls-files`).

```lua
require("workspace-diagnostics").setup({
  workspace_files = function()
    return { 'index.js', 'lib/banana.js' }
  end
})
```


## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

To run `make lint` locally, you'd need to install [stylua](https://github.com/JohnnyMorganz/StyLua#installation):

```sh
cargo install stylua --features lua52
```
