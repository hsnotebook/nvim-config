local M = {}

local is_heading = function (line)
  return string.match(line, '^#+')
end
local heading_level = function (line)
  return string.len(string.match(line, '^#+'))
end
local heading_content = function (line)
  return string.match(line, '[^# ].*')
end

local Heading = {}
function Heading:new(start_line, line)
  self.__index = self
  local heading = {
    content = heading_content(line),
    level = heading_level(line),
    start_line = start_line,
    self_end_line = 0,
    total_end_line = 0,
    sub_headings = {}
  }
  return setmetatable(heading, self)
end
function Heading:add(heading)
  if heading.level - self.level == 1 then
    table.insert(self.sub_headings, heading)
  else
    local last_sub_heading = self.sub_headings[#self.sub_headings]
    if not last_sub_heading then
      -- TODO
      -- print("heading level is not correct!")
    else
      last_sub_heading:add(heading)
    end
  end
end
function Heading:setup_self_end_line()
  if #self.sub_headings > 0 then
    local first_sub_heading = self.sub_headings[1]
    self.self_end_line = first_sub_heading.start_line - 1

    for _, heading in ipairs(self.sub_headings) do
      heading:setup_self_end_line()
    end
  else
    local origin_cursor = vim.api.nvim_win_get_cursor(0)
    vim.fn.cursor(self.start_line + 1, 0)
    local next_heading_line = vim.fn.search('^#')
    if next_heading_line == 1 then
      self.self_end_line = vim.fn.line('$')
    else
      self.self_end_line = next_heading_line - 1
    end
    vim.fn.cursor(origin_cursor[1], origin_cursor[2])
  end
end
function Heading:get_total_end_line()
  if #self.sub_headings > 0 then
    local last_sub_heading = self.sub_headings[#self.sub_headings]
    return last_sub_heading:get_total_end_line()
  else
    return self.self_end_line
  end
end
function Heading:setup_total_end_line()
  if #self.sub_headings > 0 then
    local last_sub_heading = self.sub_headings[#self.sub_headings]
    self.total_end_line = last_sub_heading:get_total_end_line()

    for _, sub_heading in ipairs(self.sub_headings) do
      sub_heading:setup_total_end_line()
    end
  else
    self.total_end_line = self.self_end_line
  end
end
function Heading:fold(level)
  if self.level == level then
    vim.cmd(self.start_line .. ',' .. self.total_end_line .. 'fold')
  else
    if self.self_end_line > self.start_line then
      vim.cmd(self.start_line .. ',' .. self.self_end_line .. 'fold')
    end
    for _, heading in ipairs(self.sub_headings) do
      heading:fold(level)
    end
  end
end
function Heading:max_level()
  local max_level = 1
  if #self.sub_headings > 0 then
    for _, sub_heading in ipairs(self.sub_headings) do
      local level = sub_heading:max_level()
      if level > max_level then
        max_level = level
      end
    end
    return max_level + 1
  else
    return max_level
  end
end

local top_headings = function ()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local headings = {}
  for line_num, line in ipairs(lines) do
    if (is_heading(line)) then
      table.insert(headings, Heading:new(line_num, line))
    end
  end

  local top_headings = {}
  local last_level_one_heading = {}
  for i = 1, #headings do
    local heading = headings[i]
    if heading.level == 1 then
      last_level_one_heading = heading
      table.insert(top_headings, heading)
    else
      last_level_one_heading:add(heading)
    end
  end
  for _, heading in ipairs(top_headings) do
    heading:setup_self_end_line()
    heading:setup_total_end_line()
  end
  return top_headings
end

local current_level = 0

M.cycle_heading = function ()
  vim.cmd('normal zE')

  local max_level = 0
  local headings = top_headings()

  for _, heading in ipairs(headings) do
    local level = heading:max_level()
    if level > max_level then
      max_level = level
    end
  end

  current_level = current_level + 1
  if current_level > max_level then
    current_level = 0
  else
    for _, heading in ipairs(headings) do
      heading:fold(current_level)
    end
  end
  vim.cmd('normal zz')
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("wiki-heading", {clear=true}),
  pattern = "markdown",
  callback = function ()
    vim.keymap.set('n', '<S-Tab>', M.cycle_heading, {buffer=true})
    vim.keymap.set('n', '<Tab>', "za" , {buffer=true})
  end
})

return M
