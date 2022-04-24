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


setup_pyenv() {
    export PYENV_ROOT=${HOME}/.pyenv
    export PATH=${PYENV_ROOT}/bin:$PATH

    echo "export PYENV_ROOT=${PYENV_ROOT}" >> ~/.zshrc
    echo "export PATH=${PYENV_ROOT}/bin:$PATH" >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
}


install_dotfiles() {
    # https://github.com/sorin-ionescu/prezto
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
    link_files `pwd`/pyenv ~/.pyenv
}

setup_git_submodule
install_dotfiles
setup_pyenv
