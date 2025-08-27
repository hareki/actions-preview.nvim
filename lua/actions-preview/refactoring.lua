local M = {}

local RefactoringAction = {}
M.RefactoringAction = RefactoringAction

function RefactoringAction.new(refactor_name)
  return setmetatable({
    refactor_name = refactor_name,
  }, { __index = RefactoringAction })
end

function RefactoringAction:client_name()
  return "refactor"
end

function RefactoringAction:title()
  return self.refactor_name
end

function RefactoringAction:preview(callback)
  -- Refactoring actions don't have preview available
  self.previewed = {
    syntax = "",
    lines = { "Preview is not available for this action" },
  }
  callback(self.previewed)
end

function RefactoringAction:apply()
  local ok, refactoring = pcall(require, "refactoring")
  if not ok then
    vim.notify("refactoring.nvim is not available", vim.log.levels.ERROR)
    return
  end

  -- Handle the refactoring similar to the telescope integration
  vim.schedule(function()
    local keys = refactoring.refactor(self.refactor_name)
    if keys == "g@" then
      keys = "gvg@"
    end
    vim.cmd.normal(keys)
  end)
end

return M
