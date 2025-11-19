local M = {}

local keys = {
  left = "<Left>",
  right = "<Right>",
  backspace = "<BS>",
  delete = "<Del>",
}

local default_pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

local default_opts = {
  pairs = default_pairs,
  disable_filetypes = { "TelescopePrompt", "neo-tree" },
  map_backspace = true,
}

local function to_set(list)
  local set = {}
  if type(list) ~= "table" then
    return set
  end
  for _, ft in ipairs(list) do
    set[ft] = true
  end
  return set
end

local function merge_pairs(base, extra)
  local result = {}
  for open, close in pairs(base) do
    result[open] = close
  end
  if type(extra) == "table" then
    for open, close in pairs(extra) do
      result[open] = close
    end
  end
  return result
end

local function is_disabled(disable_set)
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  return disable_set[ft]
end

local function char_at(line, index)
  if index < 1 or index > #line then
    return nil
  end
  return line:sub(index, index)
end

local function is_word_char(char)
  return char and char:match("%w") ~= nil
end

local function build_close_lookup(pair_map)
  local lookup = {}
  for open, close in pairs(pair_map) do
    lookup[close] = open
  end
  return lookup
end

local function wrap_quote(open, prev_char)
  return true
end

function M.setup(opts)
  opts = opts or {}
  local config = {}
  config.pairs = merge_pairs(default_opts.pairs, opts.pairs)
  config.disable_filetypes = to_set(opts.disable_filetypes or default_opts.disable_filetypes)
  config.map_backspace = opts.map_backspace == nil and default_opts.map_backspace or opts.map_backspace
  M.config = config
  M.close_lookup = build_close_lookup(config.pairs)

  local set = vim.keymap.set
  local km_opts = { expr = true, silent = true, noremap = true, desc = "autopairs" }

  for open, close in pairs(config.pairs) do
    if open == close then
      set("i", open, function()
        if next(config.disable_filetypes) ~= nil and is_disabled(config.disable_filetypes) then
          return open
        end
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local next_char = char_at(line, col + 1)
        if next_char == close then
          return keys.right
        end
        if next_char and next_char:match("%S") and next_char ~= close then
          return open
        end
        return open .. close .. keys.left
      end, km_opts)
    else
      set("i", open, function()
        if next(config.disable_filetypes) ~= nil and is_disabled(config.disable_filetypes) then
          return open
        end
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local prev_char = char_at(line, col)
        if not wrap_quote(open, prev_char) then
          return open
        end
        local next_char = char_at(line, col + 1)
        if next_char and next_char:match("%S") and next_char ~= close then
          return open
        end
        return open .. close .. keys.left
      end, km_opts)
    end
  end

  for close, open in pairs(M.close_lookup) do
    if open ~= close then
      set("i", close, function()
        if next(config.disable_filetypes) ~= nil and is_disabled(config.disable_filetypes) then
          return close
        end
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local next_char = char_at(line, col + 1)
        if next_char == close then
          return keys.right
        end
        return close
      end, km_opts)
    end
  end

  if config.map_backspace then
    set("i", "<BS>", function()
      if next(config.disable_filetypes) ~= nil and is_disabled(config.disable_filetypes) then
        return keys.backspace
      end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local prev_char = char_at(line, col)
      local next_char = char_at(line, col + 1)
      if prev_char and next_char and config.pairs[prev_char] == next_char then
        return keys.backspace .. keys.delete
      end
      return keys.backspace
    end, km_opts)
  end
end

return M
