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
  -- Git resolves bcomp/bcompare and honors difftool.bc.path itself.

  local function git(args, cwd, on_success, timeout)
    local cmd = { "git" }
    vim.list_extend(cmd, args)
    local launched, launch_err = pcall(vim.system, cmd, { cwd = cwd, timeout = timeout }, vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        local message = vim.trim(result.stderr or "")
        if message == "" then
          message = result.code == 124 and "Git command timed out" or "Git command failed"
        end
        fail("Beyond Compare: " .. message)
      elseif on_success then
        on_success(result.stdout)
      end
    end))
    if not launched then
      fail("Beyond Compare: " .. tostring(launch_err))
    end
  end

  git({ "rev-parse", "--show-toplevel" }, vim.fs.dirname(file), function(root)
    root = vim.trim(root)
    local path = vim.fs.relpath(root, file)
    if not path then
      return fail("Beyond Compare: file is outside the Git working tree")
    end

    local function compare(revision)
      local args = { "--literal-pathspecs", "difftool", "--no-prompt", "--tool=bc" }
      if revision then
        table.insert(args, vim.trim(revision))
      end
      vim.list_extend(args, { "--", path })
      -- Git manages temporary files; leave the comparison process without a timeout.
      git(args, root)
    end

    if ref ~= "" then
      git({ "rev-parse", "--verify", "--end-of-options", ref .. "^{commit}" }, root, compare, 5000)
    else
      compare()
    end
  end, 5000)
end

return M
