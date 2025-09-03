-- Basic settings
vim.opt.number = true                              -- Line numbers
vim.opt.relativenumber = true                      -- Relative line numbers
vim.opt.cursorline = true                          -- Highlight current line
vim.opt.wrap = false                               -- Don't wrap lines
vim.opt.scrolloff = 10                             -- Keep 10 lines above/below cursor 
vim.opt.sidescrolloff = 8                          -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 2                                -- Tab width
vim.opt.shiftwidth = 2                             -- Indent width
vim.opt.softtabstop = 2                            -- Soft tab stop
vim.opt.expandtab = true                           -- Use spaces instead of tabs
vim.opt.smartindent = true                         -- Smart auto-indenting
vim.opt.autoindent = true                          -- Copy indent from current line

-- Set tabs for C and C header files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.h",
  callback = function()
    vim.bo.filetype = "c"  -- Treat .h as C files
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "h" },
  callback = function()
    vim.bo.expandtab = false  -- Use actual tabs
    -- vim.bo.tabstop = 4
    -- vim.bo.shiftwidth = 4
  end,
})

-- Search settings
vim.opt.ignorecase = true                          -- Case insensitive search
vim.opt.smartcase = true                           -- Case sensitive if uppercase in search
vim.opt.hlsearch = false                           -- Don't highlight search results 
vim.opt.incsearch = true                           -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true                       -- Enable 24-bit colors
vim.opt.signcolumn = "yes"                         -- Always show sign column
vim.opt.colorcolumn = "80"                        -- Show column at 100 characters
vim.opt.showmatch = true                           -- Highlight matching brackets
vim.opt.matchtime = 2                              -- How long to show matching bracket
vim.opt.cmdheight = 1                              -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect"  -- Completion options 
vim.opt.showmode = false                           -- Don't show mode in command line 
vim.opt.pumheight = 10                             -- Popup menu height 
vim.opt.pumblend = 10                              -- Popup menu transparency 
vim.opt.winblend = 0                               -- Floating window transparency 
vim.opt.conceallevel = 0                           -- Don't hide markup 
vim.opt.concealcursor = ""                         -- Don't hide cursor line markup 
vim.opt.lazyredraw = true                          -- Don't redraw during macros
vim.opt.synmaxcol = 300                            -- Syntax highlighting limit 

-- File handling
vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false                           -- Don't create swap files
vim.opt.undofile = true                            -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
vim.opt.updatetime = 300                           -- Faster completion
vim.opt.timeoutlen = 500                           -- Key timeout duration
vim.opt.ttimeoutlen = 0                            -- Key code timeout
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false                          -- Don't auto save

-- Behavior settings
vim.opt.hidden = true                              -- Allow hidden buffers
vim.opt.errorbells = false                         -- No error bells
vim.opt.backspace = "indent,eol,start"             -- Better backspace behavior
vim.opt.autochdir = false                          -- Don't auto change directory
vim.opt.iskeyword:append("-")                      -- Treat dash as part of word
vim.opt.path:append("**")                          -- include subdirectories in search
vim.opt.selection = "exclusive"                    -- Selection behavior
vim.opt.mouse = ""                                -- Enable mouse support
vim.opt.clipboard:append("unnamedplus")            -- Use system clipboard
vim.opt.modifiable = true                          -- Allow buffer modifications
vim.opt.encoding = "UTF-8"                         -- Set encoding

-- Cursor settings
-- === Adaptive cursor (works in TUI + GUI) ===
-- Keep your block cursor everywhere; invert the cell under it for contrast.

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:block,o:block,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Detect common GUIs; adjust if you use another
local is_gui = vim.g.neovide or vim.g.goneovim or vim.g.nvim_gui_shim

-- Highlight group for the single cell under cursor: reverse ensures contrast,
-- nocombine prevents syntax colors from overpowering it.
vim.api.nvim_set_hl(0, "AdaptiveCursorChar", { reverse = true, nocombine = true })

local ns = vim.api.nvim_create_namespace("adaptive_cursor_char")
local mark = nil

local function clear_mark(buf)
  if mark then pcall(vim.api.nvim_buf_del_extmark, buf, ns, mark) end
  mark = nil
end

local function update_mark()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  if not vim.api.nvim_buf_is_loaded(buf) then return end
  clear_mark(buf)

  local pos = vim.api.nvim_win_get_cursor(win)
  local row = pos[1] - 1
  local col = pos[2]

  -- Get the current line; skip if at EOL or on an empty line
  local line = (vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]) or ""
  if #line == 0 or col >= #line then return end

  -- Draw a 1-cell highlight exactly under the cursor
  mark = vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
    end_col = col + 1,
    hl_group = "AdaptiveCursorChar",
    priority = 10000,   -- sit above most highlights
    hl_mode = "combine" -- keep things like visual selection borders
  })
end

-- Update on cursor movement, mode changes, buffer/window changes
vim.api.nvim_create_autocmd(
  { "CursorMoved", "CursorMovedI", "WinEnter", "BufEnter", "InsertEnter", "ModeChanged" },
  { callback = update_mark }
)

-- Clean up when leaving
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function(args) clear_mark(args.buf) end
})

-- Optional: in GUI, also invert the real cursor highlight so it adapts too
if is_gui then
  vim.api.nvim_set_hl(0, "Cursor",  { reverse = true, nocombine = true })
  vim.api.nvim_set_hl(0, "lCursor", { reverse = true, nocombine = true })
end

-- Folding settings
vim.opt.foldmethod = "expr"                        -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"    -- Use treesitter for folding
vim.opt.foldlevel = 99                             -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true                          -- Horizontal splits go below
vim.opt.splitright = true                          -- Vertical splits go right
