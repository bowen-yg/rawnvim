return {
  "ibhagwan/fzf-lua",
  lazy=true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostics disable: missing-fields
  opts = {
    fzf_bin = 'sk',
    winopts={
      height= 0.90,
      width= 0.85,
      preview = {layout = "horizontal",} },
  },
  ---@diagnostics enable: missing-fields
}
