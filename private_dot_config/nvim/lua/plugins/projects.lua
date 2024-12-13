return {
	"ahmedkhalf/project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern" },
			patterns = { ".git", "package.json", "Makefile" },
		})
		require("telescope").load_extension("projects")
	end,
	keys = {
		{
			"<Leader>fp",
			vim.schedule_wrap(function()
				require("telescope").extensions.projects.projects({})
			end),
			desc = "Switch project",
		},
	},
}
