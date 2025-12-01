# Agent Guidelines for gh-actions-lsp.nvim

## Build/Test/Lint Commands
- **Test**: `make test` (runs headless Neovim tests with Plenary)
- **Lint/Format**: `stylua --color always --check lua` (check) or `stylua lua` (fix)
- **Single test**: Tests use PlenaryBustedDirectory, run individual specs with `:PlenaryBustedFile tests/<file>`

## Code Style Guidelines
- **Formatting**: StyLua with 120 char width, 2-space indents, Unix line endings, double quotes preferred
- **Files**: kebab-case (`gh-actions-lsp.lua`)
- **Functions/Variables**: snake_case (`get_repo_name`, `session_token`)
- **Imports**: PascalCase for modules (`local GithubAPI = require("gh-actions-lsp.api.github")`)
- **Module pattern**: `local M = {}` at top, `return M` at bottom

## Error Handling & Types
- Use `pcall()` for risky operations: `local ok, data = pcall(vim.json.decode, raw_json)`
- Explicit nil checks: `if not result or not result.stdout then`
- LSP error responses with proper codes: `{ code = -32602, message = 'Error description' }`
- LuaLS annotations: `---@param repo_name string`, `---@return table`

## Architecture Notes
- Neovim LSP plugin that integrates with `gh-actions-language-server` binary
- Uses `vim.system()` for external commands, auto-detects GitHub workflow files
- Module structure: `gh-actions-lsp.api.*` for API components, main logic in `lua/gh-actions-lsp/init.lua`