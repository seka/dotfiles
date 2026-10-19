if vim.fn.has("nvim-0.12") == 0 then
  return
end

local query = vim.treesitter.query
local originals = {
  add_predicate = query.add_predicate,
  add_directive = query.add_directive,
}

-- Neovim 0.12 removed all=false support, but the legacy plugin still expects one node per capture.
for name, register in pairs(originals) do
  query[name] = function(predicate, handler, opts)
    if type(opts) == "table" and opts.all == false then
      local legacy_handler = handler
      handler = function(match, ...)
        local captures = {}
        for id, nodes in pairs(match) do
          captures[id] = nodes[#nodes]
        end
        return legacy_handler(captures, ...)
      end
    end
    return register(predicate, handler, opts)
  end
end

local ok, err = pcall(require, "nvim-treesitter.query_predicates")
for name, register in pairs(originals) do
  query[name] = register
end

if not ok then
  error(err)
end
