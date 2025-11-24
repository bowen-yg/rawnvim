require("options")
require("keymap")
require("autopairs").setup()
require("statusline").setup()
if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF:h16"
  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 3.0
  vim.g.neovide_floating_corner_radius = 0.8
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 15
  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 1
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_speed = 8.0
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_fullscreen = false
end
