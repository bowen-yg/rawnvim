require("options")
require("keymap")
require("autopairs").setup()
require("statusline").setup()
require("config.lazy")
vim.opt.tags:append("tags")
if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF:h17"
  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0
  vim.g.neovide_floating_corner_radius = 0.8
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 15
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_scroll_animation_length = 0.5
  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 1
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_speed = 8.0
  vim.g.neovide_cursor_animation_length = 0.2
  vim.g.neovide_refresh_rate_idle = 3
  vim.g.neovide_fullscreen = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_progress_bar_enabled = false
end
vim.cmd.colorscheme 'kanagawa-wave'
