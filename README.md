<p align="center">
  <h1 align="center">workspace-diagnostics.nvim</h2>
</p>

<p align="center">
    Populates project-wide lsp diagnostcs, regardless of what files are opened.
</p>

<details>
  <summary>Demo</summary>
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
use {"workspace-diagnostics.nvim"}
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
Plug "workspace-diagnostics.nvim"
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
require("lazy").setup({"workspace-diagnostics.nvim"})
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

To run `make lint` locally, you'd need to install `stylua`:

```sh
cargo install stylua --features lua52
```
