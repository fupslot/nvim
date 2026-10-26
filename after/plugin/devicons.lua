require("nvim-web-devicons").setup({
	color_icons = true,

  strict = true,

  override_by_filename = {
    [".ignore"] = {
      icon = "",
      color = "#a3e635",
      name = "Ignore",
    }
  },

	override_by_extension = {
		["lock"] = {
			icon = "",
			color = "#fb923c",
			name = "Ignore",
		},
	},
})
