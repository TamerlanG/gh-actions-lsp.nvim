# gh-actions-lsp.nvim 

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A Neovim plugin that integrates with the GitHub Actions Language Server to provide LSP features for GitHub workflow files.

## Prerequisites

### 1. GitHub Actions Language Server

This plugin requires the `gh-actions-language-server` binary to be installed. You can install it via npm:

```bash
npm install -g @github/gh-actions-language-server
```

### 2. GitHub Token

You must set a GitHub token as an environment variable for the language server to function properly. The token is required to access GitHub's API for workflow validation and completion.

Set the `GHCRIO` environment variable with your GitHub token:

```bash
export GHCRIO=your_github_token_here
```

To make this permanent, add it to your shell configuration file (`.bashrc`, `.zshrc`, etc.):

```bash
echo 'export GHCRIO=your_github_token_here' >> ~/.bashrc
# or for zsh:
echo 'export GHCRIO=your_github_token_here' >> ~/.zshrc
```

**Note:** You can generate a GitHub token at [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens). The token needs appropriate permissions to access repository information.

## Installation

### Lazy.nvim

Add the following to your Lazy.nvim configuration:

```lua
{
  "tamerlang/gh-actions-lsp.nvim",
  opts = {}
}
```

Or with custom configuration:

```lua
{
  "tamerlang/gh-actions-lsp.nvim",
  opts = {
      fallback_org = "random-org", -- Optional: specify a fallback organization if organization cannot be determined in repo
  },
  event = "VeryLazy" 
}
```
