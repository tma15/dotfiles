#!/bin/zsh

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}


setup_git_submodule() {
    git submodule update --init --recursive
    success "git submodule update --init --recursive"
}


link_files() {
    ln -ns $1 $2
    success "linked $1 to $2"
}


install_dotfiles() {
    # https://github.com/sorin-ionescu/prezto
    link_files `pwd`/zprezto ~/.zprezto
    link_files `pwd`/zprezto/runcoms/zlogin ~/.zlogin
    link_files `pwd`/zprezto/runcoms/zlogout ~/.zlogout
    link_files `pwd`/zprezto/runcoms/zprofile ~/.zprofile
    link_files `pwd`/zprezto/runcoms/zshenv ~/.zshenv

    link_files `pwd`/pyenv ~/.pyenv
    link_files `pwd`/tmux.conf ~/.tmux.conf
    link_files `pwd`/vimrc ~/.vimrc
    link_files `pwd`/vim ~/.vim
    link_files `pwd`/zshrc ~/.zshrc
    link_files `pwd`/zpreztorc ~/.zpreztorc
}

setup_git_submodule
install_dotfiles
