local M = {}

M.checks = {}

function M.check()
  vim.health.start("gh-actions-lsp.nvim")

  local lsp_bin = 'gh-actions-language-server'
  if vim.fn.executable('gh-actions-language-server') == 1 then
    vim.health.ok(lsp_bin .. " is installed")
  else
    vim.health.error(lsp_bin .. " is not installed")
  end
end

return M
