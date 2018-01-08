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
autocmd BufNewFile,BufRead *.cuh set filetype=cpp
autocmd BufNewFile,BufRead *.j2 set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=html
autocmd BufNewFile,BufRead *.markdown set filetype=html
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

"set rtp+=$GOROOT/misc/vim
"exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle
	call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'davidhalter/jedi'
NeoBundle 'EnhCommentify.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'surround.vim'
NeoBundle 'EasyMotion'
NeoBundle 'Pydiction'
NeoBundle 'autodate.vim'
NeoBundle 'surround.vim'
NeoBundle 'quickrun'
NeoBundle 'fatih/vim-go'
NeoBundle 'gabrielelana/vim-markdown'

syntax enable
filetype plugin indent on     " (5)

"""""""""""""""""
" colorscheme
"""""""""""""""""
colorscheme molokai

""""""""""""""""
" powerline
"""""""""""""""
set rtp+=~/.virtualenvs/py27/lib/python2.7/site-packages/powerline/bindings/vim
set guifont=Ricty\ Regular\ for\ Powerline.ttf
"let g:Powerline_symbols='fancy'

""""""""""""""""
" Unite.vim
""""""""""""""""
" list buffer
noremap <C-U><C-B> :Unite buffer<CR> 
" list of files in the directory of currently opened file
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
" list of files those which are opened recently
noremap <C-U><C-Y> :Unite file_mru<CR>
" list of register
noremap <C-U><C-R> :Unite -buffer-name=register register<CR>
" Create new file
noremap <C-U><C-N> :<C-u>UniteWithBufferDir file file/new -buffer-name=file<CR>

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

"""""""""""""""""""""
" VimShell
"""""""""""""""""""""
" vimshell setting
let g:vimshell_interactive_update_time = 10

" vimshell map
nnoremap <silent> vs :VimShell<CR>
nnoremap <silent> vsc :VimShellCreate<CR>
nnoremap <silent> vp :VimShellPop<CR>
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" :

"""""""""""""""""""""
" quickrun
"""""""""""""""""""""
let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
      \ 'outputter': 'browser'
      \ }

"""""""""""""""""
" Pydiction
"""""""""""""""""
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'

"""""""""""""""""
" Jedi
"""""""""""""""""
let g:jedi#auto_initialization = 1
let g:jedi#rename_command= "<leader>R"
let g:jedi#pupup_on_dot = 1
autocmd FileType python let b:did_ftplugin = 1

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

noremap <CR> o<ESC>
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
"let g:neocomplcache_enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completionin
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif

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


""" vim-markdown
let g:markdown_enable_spell_checking = 0
