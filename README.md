<p align="center">
  <h1 align="center">🔌  Neovim plugin boilerplate</h2>
</p>

<p align="center">
    Plug and play Neovim plugin boilerplate with pre-configured CI, CD, linter, docs and tests.
</p>

## ⚡️ Features

- interactive `setup` script
- README.md template
- Perfect for open-source:
  - CODEOWNERS file for PR auto-assign
  - Issues and PR templates
- CD leveraging [release-please-action](https://github.com/google-github-actions/release-please-action)
- CI:
  - Test running on multiple Neovim version
  - Lint check
  - Documentation generation check
  - Minimal run time, ideal for free plans
- Docs with [mini.nvim `doc` plugin](https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/doc.lua)
- Tests with [mini.nvim `test` plugin](https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/test.lua)
- Linting with [Stylua](https://github.com/JohnnyMorganz/StyLua)

## 📋 Installation

> **Note**:
> This section is only required if you wish to use the linter provided by the template.

- [Install Stylua linter](https://github.com/JohnnyMorganz/StyLua#installation)

## ☄ Getting started

The following checklist is all your need to do to start writing your first plugin.

### 1 - Clone the template repository

#### via HTTPs

```sh
git clone https://github.com/shortcuts/neovim-plugin-boilerplate.git ~/my-awesome-plugin.nvim
```

#### via SSH

```sh
git clone git@github.com:shortcuts/neovim-plugin-boilerplate.git ~/my-awesome-plugin.nvim
```

#### via GH
```sh
gh repo create my-awesome-plugin --template shortcuts/neovim-plugin-boilerplate --public --clone
```

### 2 - Replace placeholder names with your plugin name

#### Automatically

The [setup script](https://github.com/shortcuts/neovim-plugin-boilerplate/blob/main/scripts/setup.sh) will rename files and placeholder names for you. Once done, you can remove anything `setup` related if you want to.

```sh
# interactive
make setup

# automated
USERNAME=my-github-username PLUGIN_NAME=my-awesome-plugin REPOSITORY_NAME=my-awesome-plugin.nvim make setup
```

#### Manually

> **Note**:
> The placeholder names are purposely written with different casing. Make sure to keep it.

#### File names

```sh
rm -rf doc
mv plugin/your-plugin-name.lua plugin/my-awesome-plugin.lua
mv lua/your-plugin-name lua/my-awesome-plugin
mv README_TEMPLATE.md README.md 

```

#### Search and replace placeholder occurrences:

```vim
:vimgrep /YourPluginName/ **/*
:cfdo %s/YourPluginName/MyAwesomePlugin/g | update

:vimgrep /your-plugin-name/ **/* .github/**
:cfdo %s/your-plugin-name/my-awesome-plugin/g | update

:vimgrep /YOUR_GITHUB_USERNAME/ .github/** **/*.md
:cfdo %s/YOUR_GITHUB_USERNAME/shortcuts/g | update

:vimgrep /YOUR_REPOSITORY_NAME/ **/*.md
:cfdo %s/YOUR_REPOSITORY_NAME/my-awesome-plugin.nvim/g | update
```

### 3 - Code

You can now start writing your plugin, make sure the following commands work:
1. `make deps` to install docs/tests dependencies
2. `make lint` to format the code
3. `make documentation` to generate the documentation
4. `make test` to run the tests

Enjoy!

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.
