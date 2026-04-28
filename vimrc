set enc=utf-8
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8

" 256 colors
if exists('&t_Co')
  set t_Co=256
endif

set nu
set completeopt=menuone
syntax on " syntax hilighting
filetype on
set hlsearch
set showmatch
set laststatus=2
if !has('nvim') && exists('&guioptions')
  set guioptions+=a
endif

set wildmenu

" Wildmenu
if has("wildmenu")
  set wildignore+=*.a,*.o
  set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
  set wildignore+=.DS_Store,.git,.hg,.svn
  set wildignore+=*~,*.swp,*.tmp
  set wildmenu
  set wildmode=longest,list
endif

" Read NewFile as specified filetype
autocmd FileType javascript setl tabstop=8 expandtab shiftwidth=2 softtabstop=2
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python,md,rst,sh,zsh setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType html setl tabstop=8 expandtab shiftwidth=2 softtabstop=2
autocmd FileType cpp,cc setl tabstop=4 expandtab shiftwidth=2 softtabstop=2
autocmd FileType yaml setl tabstop=2 expandtab shiftwidth=2 softtabstop=2 noet

set nocompatible

filetype plugin indent off                   " (1)


let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_path . '/repos/github.com/Shougo/dein.vim'
let s:default_vimrc = expand('~/.vimrc')
let s:default_vimrc_resolved = resolve(s:default_vimrc)

" Keep dein's cache key stable even when ~/.vimrc is a symlink to this repo.
if $MYVIMRC ==# '' || resolve(expand($MYVIMRC)) ==# s:default_vimrc_resolved
  let $MYVIMRC = s:default_vimrc
endif

let s:dein_state = s:dein_path . '/state_' . fnamemodify(v:progname, ':r') . '.vim'
let s:dein_cache = s:dein_path . '/cache_' . fnamemodify(v:progname, ':r')
let s:stale_runtime = s:dein_path . '/.cache/vimrc/.dein'

" If a state file points at an empty merged runtime cache, force a rebuild.
if filereadable(s:dein_state)
  let s:state_runtime_line = 'let g:dein#_runtime_path = ' . string(s:stale_runtime)
  if index(readfile(s:dein_state), s:state_runtime_line) >= 0
        \ && !filereadable(s:stale_runtime . '/autoload/ddc.vim')
    call delete(s:dein_state)
    call delete(s:dein_cache)
  endif
endif

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)
  
  let g:config_dir  = expand('~/.vim/dein/userconfig')
  let s:toml        = g:config_dir . '/plugins.toml'
  let s:lazy_toml   = g:config_dir . '/plugins_lazy.toml'
  
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  
  call dein#end()
  call dein#save_state()

  " Rebuild dein's generated runtime tree if the cache directory is empty.
  if !exists('g:dein#_runtime_path')
        \ || empty(globpath(g:dein#_runtime_path, '*', 0, 1))
    call dein#recache_runtimepath()
  endif
endif

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

syntax enable
filetype plugin indent on     " (5)


"""""""""""""""""
" colorscheme
"""""""""""""""""
silent! colorscheme molokai

"""""""""""""""""""""
" ctrlp
"""""""""""""""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

""""
" denops
"""
let g:denops#debug = 0

"""
" vim-lsp
""""
" Enables a floating window of diagnostic error for the current line to status
let g:lsp_diagnostics_float_cursor = 1

" Disables virtual text to be shown next to diagnostic errors.
let g:lsp_diagnostics_virtual_text_enabled = 0

" Go to definition.
nnoremap <C-]> :<C-u>LspDefinition<CR>

" Gets the hover information and displays it in the preview-window
nnoremap K :<C-u>LspHover<CR>


let g:lsp_settings = {
\   'pylsp-all': {
\     'cmd': [expand('~/.vim/bin/pylsp-all')],
\     'workspace_config': {
\       'pylsp': {
\         'configurationSources': ['flake8'],
\         'plugins': {
\           'pylsp_mypy': {
\             'enabled': 1,
\             'live_mode': 0,
\           },
\           'pycodestyle': {
\             'enabled': 0,
\           },
\           'flake8': {
\             'enabled': 1,
\             'maxLineLength': 88,
\           },
\           'black': {
\             'enabled': 1,
\             'line_length': 88,
\           },
\           'yapf': {
\             'enabled': 0,
\           },
\           'autopep8': {
\             'enabled': 0,
\           },
\           'isort': {
\             'enabled': 1,
\           },
\         }
\       }
\     }
\   },
\}

"""""
" ddc
"""""
let s:ddc_supported = (has('nvim-0.11.3') || has('patch-9.1.1646')) && executable('deno')
let s:ddc_available = s:ddc_supported
      \ && !empty(globpath(&runtimepath, 'autoload/ddc.vim'))
      \ && !empty(globpath(&runtimepath, 'autoload/ddc/custom.vim'))

if s:ddc_available
  call ddc#custom#patch_global('ui', 'pum.vim')
  call ddc#custom#patch_global('ui', 'native')
  call ddc#custom#patch_global('sources', [
   \ 'around',
   \ 'vim-lsp',
   \ 'file',
   \ 'neosnippet'
   \ ])
  call ddc#custom#patch_global('sourceOptions', {
   \ '_': {
   \   'matchers': ['matcher_head'],
   \   'sorters': ['sorter_rank'],
   \   'converters': ['converter_remove_overlap'],
   \ },
   \ 'around': {'mark': 'Around'},
   \ 'neosnippet': {'mark': 'Snippet'},
   \ 'vim-lsp': {
   \   'mark': 'LSP',
   \   'matchers': ['matcher_head'],
   \   'forceCompletionPattern': '\.|:|->|"\w+/*'
   \ },
   \ 'file': {
   \   'mark': 'file',
   \   'isVolatile': v:true,
   \   'forceCompletionPattern': '\S/\S*'
   \ }})
endif


let g:lightline = {
\ 'active': {
\   'right': [ [ 'lsp_errors', 'lsp_warnings', 'lsp_ok', 'lineinfo' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_expand': {
\   'lsp_warnings': 'lightline_lsp#warnings',
\   'lsp_errors':   'lightline_lsp#errors',
\   'lsp_ok':       'lightline_lsp#ok',
\ },
\ 'component_type': {
\   'lsp_warnings': 'warning',
\   'lsp_errors':   'error',
\   'lsp_ok':       'middle',
\ },
\ }

let g:lsp_diagnostics_signs_enabled = 0
highlight link LspWarningHighlight Error

if s:ddc_available
  call ddc#enable()
endif
if s:ddc_supported && !empty(globpath(&runtimepath, 'autoload/pum/map.vim'))
  inoremap <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
  inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
endif


"""""""""""""""""""""
" Vim indent guide
"""""""""""""""""""""
" hilight indent
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd ctermbg=darkgray
autocmd VimEnter,ColorScheme * :hi IndentGuidesEven ctermbg=lightgreen
highlight Normal guifg=white guibg=black

"""""""""""""""""""""""""""""""
" neosnippet
"""""""""""""""""""""""""""""""
" Plugin key-mappings
imap <C-k>    <Plug>(neosnippet_expand_or_jump)
smap <C-k>    <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet complete marker
if has('conceal')
	set conceallevel=2 concealcursor=i
endif
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/snippet'


"""""""""""""""
" vim-markdown
"""""""""""""""
let g:markdown_enable_spell_checking = 0


""""""""""""""""""""""
" rainbow_parentheses
""""""""""""""""""""""
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
augroup RainbowParentheses
  autocmd!
  autocmd VimEnter * if exists(':RainbowParenthesesToggle') | silent! RainbowParenthesesToggle | endif
  autocmd Syntax * if exists(':RainbowParenthesesLoadRound') |
        \ silent! RainbowParenthesesLoadRound |
        \ silent! RainbowParenthesesLoadSquare |
        \ silent! RainbowParenthesesLoadBraces |
        \ endif
augroup END


augroup LspAutoFormatting
  autocmd!
  autocmd BufWritePre *.py LspDocumentFormatSync
augroup END
