local M = {}

function M.open(ref)
  local function fail(message)
    vim.notify(message, vim.log.levels.ERROR)
  end

  local file = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype ~= "" or file == "" or vim.fn.filereadable(file) ~= 1 then
    return fail("Beyond Compare: open a saved file first")
  end
  if vim.bo.modified then
    return fail("Beyond Compare: save your edits with :write first")
  end
  file = vim.uv.fs_realpath(file) or file
  if vim.fn.executable("bcomp") ~= 1 then
    return fail("Beyond Compare: bcomp is missing from PATH")
  end

  local function git(args, cwd)
    local cmd = { "git" }
    vim.list_extend(cmd, args)
    local result = vim.system(cmd, { cwd = cwd }):wait(5000)
    if result.code ~= 0 then
      fail("Beyond Compare: " .. vim.trim(result.stderr or "Git command failed"))
      return
    end
    return result.stdout
  end

  local root = git({ "rev-parse", "--show-toplevel" }, vim.fs.dirname(file))
  if not root then
    return
  end
  root = vim.trim(root)
  local path = vim.fs.relpath(root, file)
  if not path then
    return fail("Beyond Compare: file is outside the Git working tree")
  end
  local revision = ""
  if ref ~= "" then
    local commit = git({ "rev-parse", "--verify", "--end-of-options", ref .. "^{commit}" }, root)
    if not commit then
      return
    end
    revision = vim.trim(commit)
  end
  local cmd = { "git", "--literal-pathspecs", "difftool", "--no-prompt", "--tool=bc" }
  if revision ~= "" then
    table.insert(cmd, revision)
  end
  vim.list_extend(cmd, { "--", path })

  -- Git manages temporary files; run asynchronously while Beyond Compare is open.
  local launched, launch_err = pcall(vim.system, cmd, { cwd = root }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = vim.trim(result.stderr or "")
        fail("Beyond Compare: " .. (message ~= "" and message or "git difftool failed"))
      end
    end)
  end)
  if not launched then
    fail("Beyond Compare: " .. tostring(launch_err))
  end
end

return M
