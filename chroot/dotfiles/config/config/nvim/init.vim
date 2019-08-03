let g:mapleader=','

" settings"
set shell=/bin/sh
set nocompatible "Remove Vim compatibility
set autoindent   "autoindent
set smartindent  "copy indentation of line above
set modifiable
set expandtab
set tabstop=2
set shiftwidth=2 "indentation amount for > and <
set softtabstop=2
set incsearch
set hlsearch "highlight search
set ignorecase "ignore case on search
set smartcase  "dont ignore case if capslock
set showcmd "dont show last cmd
set hidden "hide buffers instead of closing
set autoread "reread file if changed outside of vim
set number "show cur line number
set relativenumber "show relative num of other lines
set lazyredraw
set cmdheight=1 "only one line for cmd line
set shortmess+=c "dont give completion messages like 'match 1 of 2'
set mps+=<:> "match < and >
set splitbelow "set preview win to appear at bot
set noshowmode "dont display mode on cmd line
set updatetime=300 "speed lint of coc
set scl=no "sign column
set encoding=utf-8
set fileencoding=utf-8
set wildmenu
set wildmode=list:full,full

setlocal spell
set spelllang=en_us,pt_br
let &clipboard = has('unnamedplus') ? 'unnamedplus' : 'unnamed'
set clipboard+=unnamedplus

set backupdir=~/.local/share/nvim/backup
set nowritebackup
set nobackup
set noswapfile
if has('persistent_undo')
  set undodir=~/.local/share/nvim/undo
  set undofile
  set undolevels=3000
  set undoreload=10000
endif

"===== mappings ===="
nnoremap <leader>e :Vexplore<CR>
inoremap jk <Esc>
" save and exit
nnoremap <leader>x :x<CR>
"fix spelling mistakes
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
"easier moving between windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"don't skip multi lines
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
"disable highlight
nnoremap <leader>h :noh<CR>
"save and exit
nnoremap <leader>x :x<CR>
"save
"nmap <C-s> :w<CR>
"imap <C-s> <Esc>:w<CR>
nnoremap <leader>w :w<CR>
cmap w!! w !sudo tee % > /dev/null
"easier moving between tabs
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
"disable help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

"Copy and paste to system clipboard
nnoremap <leader>y "*y
nnoremap <leader>p "*p
nnoremap <leader>Y "+y
nnoremap <leader>P "+p

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

let g:hot_reload_on_save=1

"===== plugins ====="
call plug#begin('~/.local/share/nvim/plugged')
"plugin manager
Plug 'VundleVim/Vundle.vim'
"colorscheme
Plug 'morhetz/gruvbox'
"intellisense, completion, linting, fixing, documentation lookup
Plug 'neoclide/coc.nvim' , {'tag': '*', 'do': { -> coc#util#install()}}
"fzf, search, file manager
Plug 'Shougo/denite.nvim'
"Status Bar
Plug 'itchyny/lightline.vim'
"language highlight
Plug 'sheerun/vim-polyglot'
"icons on file explores
"auto close shit
Plug 'rstacruz/vim-closer'
"git wrapper
Plug 'tpope/vim-fugitive'
"horizontal indent line
Plug 'Yggdroot/indentline'
"emmet for vim
Plug 'mattn/emmet-vim'
"latex
Plug 'lervag/vimtex'
"snippets
Plug 'sirver/ultisnips'
" Flutter and Dart
Plug 'dart-lang/dart-vim-plugin'
call plug#end()
filetype plugin indent on


"===== plugins settings ====="
" -- DART & FLUTTER --"
let dart_style_guide=2
let dart_format_on_save=1
" -- INDENT LINE --"
let g:indentLine_setColors = 0
let g:indentLine_char = '|'	
" -- DENITE -- "
try
  " use ripgrep instead of grep
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  "remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')
  let s:denite_options = {'default': {
    \ 'auto_resize': 1,
    \ 'direction': 'rightbelow',
    \ 'highlight_mode_insert': 'Visual',
    \ 'highlight_mode_normal': 'Visual',
    \ 'prompt_highlight': 'Function',
    \ 'highlight_matched_char': 'Function',
    \ 'highlight_matched_range': 'Normal',
    \ }}
  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction
  call s:profile(s:denite_options)
catch
  echo 'Install Plugins First'
endtry

" -- COC -- "
"let g:coc_force_debug=1
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" -- LIGHTLINE -- "
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ 
  \       [ 'mode', 'paste' ],
  \       [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified', 'gitstatus']
  \   ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction',
  \   'gitstatus': 'fugitive#head'
  \ }}

" -- VIMTEX -- "
autocmd BufNewFile,BufRead *.tex IndentLinesDisable
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
set concealcursor=""
let g:indentLine_noConcealCursor=2
let g:tex_conceal='abdmg'

" -- ULTISNIPS -- "
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetsDir="/home/lucastercas/git/dotfiles/config/nvim/snippets"
let g:UltiSnipsSnippetDirectories=["/home/lucastercas/git/dotfiles/config/nvim/snippets", "UltiSnips"]

"===== plugins mappings ====="
"denite
nmap <F5> :Denite buffer -winrow=1<CR>
nmap <C-p> :Denite file/rec -split=floating -winrow=2<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
nnoremap <leader>g :<C-u>Denite grep:. -mode=normal<CR>

"coc
"inoremap <silent><expr> <c-space> coc#refresh()
"lookup of definitions, etc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
"rename current word
nmap <leader>rn <Plug>(coc-rename)
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
"show completion menu
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> <leader>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>] <Plug>(coc-diagnostic-next)
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>af <Plug>(coc-fix-current)
command! -nargs=0 Format :call CocAction('format')

nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>

augroup my_autocmd
  autocmd FileType dart nnoremap <buffer> <leader>f :!dartfmt -w .<cr>
  autocmd FileType dart call FlutterMenu()
augroup END

"===== colors ====="
set termguicolors
set t_Co=256
set background=dark
set colorcolumn=80
try
  colorscheme gruvbox
endtry
