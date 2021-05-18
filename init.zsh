#!/bin/zsh

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

setup_git_submodule() {
    git submodule update --init --recursive
    success "git sumodule update --init --recursive"
}

link_files() {
    ln -ns $1 $2
    success "linked $1 to $2"
}

install_dotfiles() {
    ###### https://github.com/sorin-ionescu/prezto
    link_files `pwd`/zprezto ~/.zprezto
    setopt EXTENDED_GLOB
    for rcfile in ~/.zprezto/runcoms/^README.md(.N)
    do
        dest=~/.`basename $rcfile`
        link_files $rcfile $dest
    done

    link_files `pwd`/tmux.conf ~/.tmux.conf
    link_files `pwd`/vimrc ~/.vimrc
    link_files `pwd`/vim ~/.vim
    vim -S ./vimexcmd.txt # vim -c ':NeoBundleInstall'
}

setup_git_submodule
install_dotfiles
