"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

let g:dein#auto_recache=1

" Required:
set runtimepath+=/Users/ozawa/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/ozawa/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('/Users/ozawa/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('preservim/nerdtree')
call dein#add('skanehira/translate.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('markonm/traces.vim')
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' })
call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})
call dein#add('jiangmiao/auto-pairs')
call dein#add('lambdalisue/fern.vim')
call dein#add('icymind/neosolarized')
call dein#add('yutkat/wb-only-current-line.nvim')
call dein#add('p00f/nvim-ts-rainbow')
call dein#add('nvim-lua/plenary.nvim')
call dein#add('nvim-telescope/telescope.nvim')
call dein#add('ryanoasis/vim-devicons')
call dein#add('Yggdroot/indentLine')
call dein#add('tomtom/tcomment_vim')

" Required:
call dein#end()

" Required:
filetype plugin indent on
"syntax enable
set number
set cursorline
set hlsearch
set incsearch
set smartindent
set laststatus=2
set wildmenu
set termguicolors
set mouse=a
set showmatch
set tabstop=2
set expandtab
set shiftwidth=2
"set list
set relativenumber

let g:neosolarized_termtrans = 1
colorscheme NeoSolarized
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

set clipboard&
set clipboard=unnamedplus

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"プラグイン削除
"call map(dein#check_clean(), "delete(v:val, 'rf')")
"call dein#recache_runtimepath()

let g:fern_disable_startup_warnings = 1
"End dein Scripts-------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		},
	indent = {
		enable = true,
		},
	rainbow = {
		enable = true,
		disable = { "html", "cpp" },-- list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
		}
	}
EOF

let g:lightline = {
      \ 'colorscheme': 'solarized' ,
      \ }
"CocSetting
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"command
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
"
"ノーマルモードで
"スペース2回でCocList
nmap <silent> <space><space> :<C-u>CocList<cr>
"スペースhでHover
nmap <silent> <space>h :<C-u>call CocAction('doHover')<cr>
"スペースdfでDefinition
nmap <silent> <space>df <Plug>(coc-definition)
"スペースrfでReferences
nmap <silent> <space>rf <Plug>(coc-references)
"スペースrnでRename
nmap <silent> <space>rn <Plug>(coc-rename)
"スペースfmtでFormat
nmap <silent> <space>fmt <Plug>(coc-format)

"Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"undo
if has('persistent_undo')
	let undo_path = expand('~/.config/nvim/undo')
	exe 'set undodir=' .. undo_path
	set undofile
endif

"NERDTreeSetting
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let NERDTreeWinSize=30

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
