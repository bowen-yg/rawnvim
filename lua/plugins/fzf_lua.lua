return {
  "ibhagwan/fzf-lua",
  lazy=true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostics disable: missing-fields
  opts = {
    winopts={ preview = {layout = "horizontal",} },
  },
  ---@diagnostics enable: missing-fields
}
