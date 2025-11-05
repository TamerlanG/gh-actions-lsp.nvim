---@param  repo_name string
---@param  token string
---@param org string
---@param workspace_path string
---@return table
local function fetch_github_repo(repo_name, token, org, workspace_path)
  local cmd = {
    "curl",
    "-H",
    "Authorization: Bearer " .. token,
    "-H",
    "User-Agent: Neovim",
    "https://api.github.com/repos/" .. org .. "/" .. repo_name,
  }

  local result = vim.system(cmd):wait()
  if not result or not result.stdout then
    print("No result from GitHub API")
    return {}
  end

  local raw_json = result.stdout
  if raw_json == "" then
    print("Empty JSON from GitHub API")
    return {}
  end

  local ok, data = pcall(vim.json.decode, raw_json)
  if not ok or type(data) ~= "table" then
    print("Failed to decode JSON from GitHub API")
    return {}
  end

  local repo_info = {
    id = data.id,
    owner = org,
    name = repo_name,
    workspaceUri = "file://" .. workspace_path,
    organizationOwned = true,
  }

  return repo_info
end


local function get_repo_name()
  local handle = io.popen("git remote get-url origin 2>/dev/null")
  if not handle then
    return nil
  end

  local result = handle:read("*a")
  handle:close()
  if not result or result == "" then
    return nil
  end
  -- Remove trailing newline
  result = result:gsub("%s+$", "")
  -- Extract repo name from URL
  local repo = result:match("([^/:]+)%.git$")
  return repo
end



return {
  fetch_github_repo = fetch_github_repo,
  get_repo_name = get_repo_name,
}
