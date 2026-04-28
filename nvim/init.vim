" Reuse the shared Vim configuration from Neovim without maintaining a
" separate plugin stack.
set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath
let $MYVIMRC = expand('~/.vimrc')
source ~/.vimrc
