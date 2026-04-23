#!/bin/zsh

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

info() {
    printf "\r\033[2K  [ \033[00;34mINFO\033[0m ] $1\n"
}

warn() {
    printf "\r\033[2K  [ \033[00;33mWARN\033[0m ] $1\n"
}

error() {
    printf "\r\033[2K  [ \033[00;31mERROR\033[0m ] $1\n"
}

check_dependencies() {
    info "Checking dependencies..."

    # Check for required commands
    local missing_deps=()

    if ! command -v git >/dev/null 2>&1; then
        missing_deps+=("git")
    fi

    if ! command -v curl >/dev/null 2>&1; then
        missing_deps+=("curl")
    fi

    if ! command -v zsh >/dev/null 2>&1; then
        missing_deps+=("zsh")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        error "Please install the missing dependencies and try again."
        exit 1
    fi

    success "All dependencies are available"
}

check_os_compatibility() {
    info "Checking OS compatibility..."

    local os_name=$(uname)
    case "$os_name" in
        "Darwin")
            success "macOS detected"
            ;;
        "Linux")
            success "Linux detected"
            ;;
        *)
            warn "Unsupported OS: $os_name (proceeding anyway)"
            ;;
    esac
}

backup_existing() {
    if [ -e $2 ] || [ -L $2 ]; then
        local backup_name="$2.backup.$(date +%Y%m%d_%H%M%S)"
        if [ -L $2 ]; then
            # If it's a symlink, just remove it
            rm $2
            info "Removed existing symlink: $2"
        else
            # If it's a regular file/directory, back it up
            mv $2 "$backup_name"
            info "Backed up existing $2 to $backup_name"
        fi
    fi
}


setup_git_submodule() {
    if git submodule update --init --recursive; then
        success "git submodule update --init --recursive"
    else
        error "Failed to initialize git submodules"
        exit 1
    fi
}


link_files() {
    backup_existing $1 $2
    ln -ns $1 $2 && success "linked $1 to $2"
}


install_deno() {
    info "Installing Deno v1.43.1..."
    # https://deno.land/
    if curl -fsSL https://deno.land/install.sh | sh -s -- v1.43.1; then
        success "installed deno"
    else
        error "Failed to install Deno"
        exit 1
    fi
}


install_dotfiles() {
    info "Installing dotfiles..."
    local private_dotfiles_dir="${DOTFILES_PRIVATE_DIR:-$HOME/work/dotfiles-private}"

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
    if [ -d "$private_dotfiles_dir" ]; then
        if [ -f "$private_dotfiles_dir/zshrc.local" ]; then
            link_files "$private_dotfiles_dir/zshrc.local" ~/.zshrc.local
        else
            warn "Private zsh overlay not found at $private_dotfiles_dir/zshrc.local. Skipping."
        fi
    fi
    mkdir -p ~/.ssh
    link_files `pwd`/ssh/config ~/.ssh/config
    if [ -d "$private_dotfiles_dir" ]; then
        if [ -f "$private_dotfiles_dir/ssh/config.local" ]; then
            link_files "$private_dotfiles_dir/ssh/config.local" ~/.ssh/config.local
        else
            warn "Private SSH overlay not found at $private_dotfiles_dir/ssh/config.local. Skipping."
        fi
    fi
    mkdir -p ~/.config/ghostty
    link_files `pwd`/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
    link_files `pwd`/ghostty/config.ghostty ~/.config/ghostty/config

    # VS Code settings (macOS specific)
    if [[ "$(uname)" == "Darwin" ]]; then
        local vscode_dir="$HOME/Library/Application Support/Code/User"
        if [ -d "$vscode_dir" ]; then
            backup_existing ~/work/dotfiles/vscode/settings.json "$vscode_dir/settings.json"
            backup_existing ~/work/dotfiles/vscode/keybindings.json "$vscode_dir/keybindings.json"
            ln -s ~/work/dotfiles/vscode/settings.json "$vscode_dir/settings.json"
            ln -s ~/work/dotfiles/vscode/keybindings.json "$vscode_dir/keybindings.json"
            success "VS Code settings linked"
        else
            warn "VS Code directory not found. Skipping VS Code settings."
        fi
    else
        warn "Non-macOS system detected. Skipping VS Code settings."
    fi

    success "Dotfiles installation completed"
}

# Main execution
info "Starting dotfiles installation..."

check_dependencies
check_os_compatibility
setup_git_submodule
install_dotfiles

if [ ! -e $HOME/.deno/bin/deno ]; then
    install_deno
fi
