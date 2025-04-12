vim.o.guicursor = ""
vim.o.mouse = ""

vim.o.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true  -- Default to spaces for most files
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.colorcolumn = "80"

-- Set tabs for C files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.bo.expandtab = false  -- Use actual tabs
    -- Optional: You can set different tab width for C if desired
    -- vim.bo.tabstop = 4
    -- vim.bo.shiftwidth = 4
  end,
})
