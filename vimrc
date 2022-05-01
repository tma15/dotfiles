set enc=utf-8
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8

" 256 colors
set t_Co=256 

set nu
set completeopt=menuone
syntax on " syntax hilighting
filetype on
set hlsearch
set showmatch
set laststatus=2
set guioptions+=a

set wildmenu
inoremap <Tab> <C-X><C-F>

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
autocmd FileType cpp setl tabstop=4 expandtab shiftwidth=2 softtabstop=2
autocmd FileType yaml setl tabstop=2 expandtab shiftwidth=2 softtabstop=2 noet

set nocompatible

filetype plugin indent off                   " (1)


let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

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

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('davidhalter/jedi-vim')
call dein#add('lambdalisue/vim-pyenv', {
	\ 'depends' : ['davidhalter/jedi-vim'],
	\ 'autoload' : {
	\   'filetypes' : ['python'],
	\ }})
call dein#add('gabrielelana/vim-markdown')
call dein#add('kien/rainbow_parentheses.vim')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('scrooloose/nerdtree')
call dein#add('Shougo/neocomplcache.vim')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('tomasr/molokai')
call dein#add('vim-scripts/EnhCommentify.vim')
"call dein#add('ervandew/supertab')

"call dein#add('Shougo/ddc.vim')
"call dein#add('vim-denops/denops.vim')
"call dein#add('vim-denops/denops-helloworld.vim')
"call dein#add('Shougo/pum.vim')
"call dein#add('Shougo/ddc-around')
"call dein#add('LumaKernel/ddc-file')
"call dein#add('Shougo/ddc-matcher_head')
"call dein#add('Shougo/ddc-sorter_rank')
"call dein#add('Shougo/ddc-converter_remove_overlap')
if !has('nvim')
  call dein#add('rhysd/vim-healthcheck')
endif

call dein#add('mattn/vim-lsp-settings')
call dein#add('prabirshrestha/vim-lsp')

call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

syntax enable
filetype plugin indent on     " (5)


"""""""""""""""""
" colorscheme
"""""""""""""""""
colorscheme molokai

"""""""""""""""""""""
" NERDTree
"""""""""""""""""""""
"nnoremap <silent><C-w> :NERDTreeToggle<CR>

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
"let g:denops#debug = 1
"let g:denops#trace = 1

" default: ['-q', '--no-check', '--unstable', '-A']
"let g:denops#server#deno_args = ['--log-level=debug', '-A']

"""""
" ddc
"""""
"call ddc#custom#patch_global('completionMenu', 'pum.vim')
"call ddc#custom#patch_global('sources', [
" \ 'around',
" \ 'vim-lsp',
" \ 'file'
" \ ])
"call ddc#custom#patch_global('sourceOptions', {
" \ '_': {
" \   'matchers': ['matcher_head'],
" \   'sorters': ['sorter_rank'],
" \   'converters': ['converter_remove_overlap'],
" \ },
" \ 'around': {'mark': 'Around'},
" \ 'vim-lsp': {
" \   'mark': 'LSP', 
" \   'matchers': ['matcher_head'],
" \   'forceCompletionPattern': '\.|:|->|"\w+/*'
" \ },
" \ 'file': {
" \   'mark': 'file',
" \   'isVolatile': v:true, 
" \   'forceCompletionPattern': '\S/\S*'
" \ }})


" <TAB>: completion.
"inoremap <silent><expr> <TAB>
"\ ddc#map#pum_visible() ? '<C-n>' :
"\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
"\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
"inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

"call ddc#enable()
"inoremap <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
"inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>



"""
" vim-lsp
""""

" Enables a floating window of diagnostic error for the current line to status
let g:lsp_diagnostics_float_cursor = 1
if executable('pyls')
  au User lsp_setup call lsp#register_server({
  \ 'name': 'pyls',
  \ 'cmd': {server_info->['pyls']},
  \ 'whitelist': ['python'],
  \ })
endif


"""""""""""""""""""""
" neocomplcache.vim
"""""""""""""""""""""
"" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" " Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" " Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

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

"""""""""""""""""
" Jedi
"""""""""""""""""
"let g:jedi#auto_initialization = 1
"let g:jedi#completions_command = "<Tab>"
"let g:jedi#popup_on_dot = 1
"let g:jedi#show_call_signatures = 1
"autocmd FileType python let b:did_ftplugin = 1
"autocmd FileType python setlocal omnifunc=jedi#completions


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
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
