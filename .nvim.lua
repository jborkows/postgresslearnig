-- Project: postgress_learning Database: PostgreSQL via Docker

-- =============================================================================
-- DADBOD (Database Connection) - using dbui format
-- =============================================================================

-- Define database connections
vim.g.dbs = {
	{
		name = "local",
		url = "postgresql://postgres:postgres@localhost:5432/postgres",
	},
	{
		name = "docker",
		url = "postgresql://postgres:postgres@postgres-db:5432/postgres",
	},
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_execute_on_save = 1

-- Set default database to first one
vim.g.db = vim.g.dbs[1].url

-- Key mapping for database UI
vim.keymap.set("n", "<leader>db", ":DBUIToggle<cr>", { desc = "Open database UI" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "dbui" },
	callback = function()
		vim.keymap.set("n", "<F8>", "<Plug>(DBUI_ExecuteQuery)", { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function()
		-- Execute current buffer content as SQL query
		vim.keymap.set("n", "<F8>", ":.DB<CR>", { silent = true, buffer = true, desc = "Execute SQL query" })
		vim.keymap.set("v", "<F8>", ":'<,'>DB<CR>", { silent = true, buffer = true, desc = "Execute selected SQL" })
	end,
})

vim.keymap.set({ "x", "o" }, "an", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })
