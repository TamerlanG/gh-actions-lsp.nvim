local GithubAPI = require("gh-actions-lsp.api.github")

local M = {}

local get_gh_actions_init_options = function(workspace_path, session_token, fallback_org)
  workspace_path = workspace_path or vim.fn.getcwd()
  session_token = session_token or os.getenv("GHCRIO")
  fallback_org = fallback_org

  local org, repo_name = GithubAPI.get_repo_info()

  -- If we couldn't infer the org from git remote, try using fallback
  if not org and fallback_org then
    org = fallback_org
    -- Still need repo name, try to get it from git remote
    repo_name = GithubAPI.get_repo_name()
  end

  if not org or not repo_name then
    print("Could not determine repository info from git remote. You can pass a fallback org via setup options.")
    return {
      sessionToken = session_token,
      repos = {},
    }
  end

  local repo_info = GithubAPI.fetch_github_repo(repo_name, session_token, org, workspace_path)
  return {
    sessionToken = session_token,
    repos = {
      repo_info,
    },
  }
end

function M.setup(opts)
  opts = opts or {}

  vim.filetype.add({
    pattern = {
      [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
    },
  })

  vim.lsp.config["gh_actions"] = {
    cmd = { "gh-actions-language-server", "--stdio" },
    filetypes = { "yaml.github" },
    init_options = get_gh_actions_init_options(nil, nil, opts.fallback_org),
    single_file_support = true,
    -- `root_dir` ensures that the LSP does not attach to all yaml files
    root_dir = function(bufnr, on_dir)
      local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
      if vim.endswith(parent, "/.github/workflows") then
        on_dir(parent)
      end
    end,
    handlers = {
      ["actions/readFile"] = function(_, result)
        if type(result.path) ~= "string" then
          return nil, { code = -32602, message = "Invalid path parameter" }
        end
        local file_path = vim.uri_to_fname(result.path)
        if vim.fn.filereadable(file_path) == 1 then
          local f = assert(io.open(file_path, "r"))
          local text = f:read("*a")
          f:close()
          return text, nil
        else
          return nil, { code = -32603, message = "File not found: " .. file_path }
        end
      end,
    },
    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
  }

  vim.lsp.enable({ "gh_actions" })
end

return M
