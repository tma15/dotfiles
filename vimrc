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

" Read NewFile as specified filetype
autocmd BufNewFile,BufRead *.j2 set filetype=html
autocmd BufNewFile,BufRead *.cu set filetype=cpp

autocmd FileType javascript setl tabstop=8 expandtab shiftwidth=2 softtabstop=2
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType go,python,md,rst,sh,zsh,html setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType cpp setl tabstop=4 expandtab shiftwidth=2 softtabstop=2
autocmd FileType go setl tabstop=4 expandtab shiftwidth=4 softtabstop=4 noet
autocmd FileType yaml setl tabstop=2 expandtab shiftwidth=2 softtabstop=2 noet
autocmd FileType cu setl tabstop=2 expandtab shiftwidth=2 softtabstop=2 noet
autocmd FileType tex setl tabstop=4 expandtab shiftwidth=2 softtabstop=2
autocmd FileType tex set spell

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
"call dein#add('vim-scripts/EasyMotion')
call dein#add('vim-scripts/EnhCommentify.vim')
"call dein#add('vim-scripts/Pydiction')
"call dein#add('vim-scripts/quickrun')
"call dein#add('vim-scripts/surround.vim')

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
let g:jedi#auto_initialization = 1
let g:jedi#rename_command= "<leader>R"
let g:jedi#popup_on_dot = 1
let g:jedi#show_call_signatures = 0
autocmd FileType python let b:did_ftplugin = 1
autocmd FileType python setlocal omnifunc=jedi#completions

" Define dictionary. 
let g:neocomplcache_dictionary_filetype_lists = { 
    \ 'default' : '', 
    \ 'vimshell' : $HOME.'/.vimshell_hist', 
    \ 'scheme' : $HOME.'/.gosh_completions' 
    \ } 

""""""""""""""""""""""
" neocomplcache
"""""""""""""""""""""
" Disable AutoComplPop
let g:acp_enableAtStartup = 0
" Use neocomplcache
let g:neocomplcache_enable_at_startup = 1
" Use smartcase
let g:neocomplcache_camel_case_completion = 1
" Use underbar completion
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_patter = '\*ku\*'

inoremap <expr><C-x><C-f>  neocomplcache#manual_filename_complete()

" Define keyword
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

"noremap <CR> o<ESC>
" Recommended key-mappings
" <CR>: close popup and save indent.
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completionin
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#close_popup()

" AutoComplPop like behavior
let g:neocomplcache_enable_auto_select = 1

" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completionin
"if !exists('g:neocomplcache_omni_patterns')
"    let g:neocomplcache_omni_patterns = {}
"endif

let g:neocomplete#sources#omni#input_patterns = {"python" : '\h\w*\|[^. \t]\.\w*'}

"""""""""""""""""""""""""""""""
" neosnippet
"""""""""""""""""""""""""""""""
" Plugin key-mappings
imap <C-k>    <Plug>(neosnippet_expand_or_jump)
smap <C-k>    <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior
imap <expr><C-l>
\ neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<C-n>"

" For snippet complete marker
if has('conceal')
	set conceallevel=2 concealcursor=i
endif


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
