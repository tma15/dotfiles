#!/bin/zsh

typeset -gr DOTFILES_DIR="${${(%):-%N}:A:h}"
typeset -gr DOTFILES_NVIM_MIN_VERSION="${DOTFILES_NVIM_MIN_VERSION:-0.11.3}"

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
    local target="$2"

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup_name="$target.backup.$(date +%Y%m%d_%H%M%S)"
        if [ -L "$target" ]; then
            # If it's a symlink, just remove it
            rm -- "$target"
            info "Removed existing symlink: $target"
        else
            # If it's a regular file/directory, back it up
            mv -- "$target" "$backup_name"
            info "Backed up existing $target to $backup_name"
        fi
    fi
}


setup_git_submodule() {
    if git -C "$DOTFILES_DIR" submodule update --init --recursive; then
        success "git submodule update --init --recursive"
    else
        error "Failed to initialize git submodules"
        exit 1
    fi
}


link_files() {
    backup_existing "$1" "$2"
    ln -ns "$1" "$2" && success "linked $1 to $2"
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


nvim_version() {
    local nvim_bin="$1"
    local first_line
    local version

    first_line="$("$nvim_bin" --version 2>/dev/null || true)"
    first_line="${first_line%%$'\n'*}"

    if [[ "$first_line" == NVIM\ v* ]]; then
        version="${first_line#NVIM v}"
    elif [[ "$first_line" == NVIM\ * ]]; then
        version="${first_line#NVIM }"
    else
        return 1
    fi

    print -r -- "${version%% *}"
}


version_at_least() {
    local version="${1#v}"
    local minimum="${2#v}"
    local version_core="${version%%[-+]*}"
    local minimum_core="${minimum%%[-+]*}"
    local -a version_parts minimum_parts
    local i version_part minimum_part

    version_parts=(${(s:.:)version_core})
    minimum_parts=(${(s:.:)minimum_core})

    for i in 1 2 3; do
        version_part="${version_parts[$i]:-0}"
        minimum_part="${minimum_parts[$i]:-0}"
        version_part="${version_part//[^0-9]/}"
        minimum_part="${minimum_part//[^0-9]/}"
        [[ -n "$version_part" ]] || version_part=0
        [[ -n "$minimum_part" ]] || minimum_part=0

        if (( version_part > minimum_part )); then
            return 0
        elif (( version_part < minimum_part )); then
            return 1
        fi
    done

    return 0
}


nvim_candidates() {
    local command_nvim

    if [[ -x "$HOME/.local/bin/nvim" ]]; then
        print -r -- "$HOME/.local/bin/nvim"
    fi

    if command -v nvim >/dev/null 2>&1; then
        command_nvim="$(command -v nvim)"
        if [[ "$command_nvim" != "$HOME/.local/bin/nvim" ]]; then
            print -r -- "$command_nvim"
        fi
    fi
}


nvim_meets_minimum() {
    local nvim_bin
    local version
    local old_version=""
    local old_bin=""

    for nvim_bin in ${(f)"$(nvim_candidates)"}; do
        version="$(nvim_version "$nvim_bin")" || continue
        if version_at_least "$version" "$DOTFILES_NVIM_MIN_VERSION"; then
            success "Neovim $version is available at $nvim_bin"
            return 0
        fi

        if [[ -z "$old_version" ]]; then
            old_version="$version"
            old_bin="$nvim_bin"
        fi
    done

    if [[ -n "$old_version" ]]; then
        warn "Neovim $old_version at $old_bin is older than $DOTFILES_NVIM_MIN_VERSION"
    else
        warn "Neovim is not installed"
    fi

    return 1
}


nvim_asset_name() {
    local os_name="$1"
    local arch_name="$2"

    [[ "$os_name" == "Linux" ]] || return 1

    case "$arch_name" in
        x86_64|amd64)
            print -r -- "nvim-linux-x86_64"
            ;;
        aarch64|arm64)
            print -r -- "nvim-linux-arm64"
            ;;
        *)
            return 1
            ;;
    esac
}


install_neovim() {
    if [[ -n "${DOTFILES_SKIP_NVIM_INSTALL:-}" ]]; then
        info "Skipping Neovim install because DOTFILES_SKIP_NVIM_INSTALL is set"
        return 0
    fi

    if nvim_meets_minimum; then
        return 0
    fi

    local os_name
    local arch_name
    local asset_name
    local archive_url
    local install_parent="${DOTFILES_NVIM_INSTALL_PARENT:-$HOME/.local/opt/dotfiles}"
    local bin_dir="${DOTFILES_NVIM_BIN_DIR:-$HOME/.local/bin}"
    local install_dir
    local archive_path
    local extract_dir
    local extracted_dir

    os_name="$(uname)"
    arch_name="$(uname -m)"
    if ! asset_name="$(nvim_asset_name "$os_name" "$arch_name")"; then
        warn "Automatic Neovim install is only supported on Linux x86_64/arm64"
        warn "Detected $os_name/$arch_name. Skipping Neovim install."
        return 0
    fi

    if ! command -v tar >/dev/null 2>&1; then
        error "tar is required to install Neovim"
        exit 1
    fi

    info "Installing Neovim $DOTFILES_NVIM_MIN_VERSION+ from official tarball..."

    archive_url="https://github.com/neovim/neovim/releases/latest/download/$asset_name.tar.gz"
    install_dir="$install_parent/$asset_name"
    archive_path="$(mktemp "${TMPDIR:-/tmp}/$asset_name.XXXXXX")"
    extract_dir="$(mktemp -d "${TMPDIR:-/tmp}/$asset_name.XXXXXX")"

    if curl -fsSL "$archive_url" -o "$archive_path"; then
        mkdir -p "$install_parent" "$bin_dir"
        tar -C "$extract_dir" -xzf "$archive_path"
        extracted_dir="$extract_dir/$asset_name"

        if [[ ! -x "$extracted_dir/bin/nvim" ]]; then
            error "Downloaded Neovim archive did not contain $asset_name/bin/nvim"
            rm -rf -- "$archive_path" "$extract_dir"
            exit 1
        fi

        rm -rf -- "$install_dir"
        mv -- "$extracted_dir" "$install_dir"
        ln -sfn "$install_dir/bin/nvim" "$bin_dir/nvim"
        rm -rf -- "$archive_path" "$extract_dir"
        success "installed Neovim to $install_dir"
    else
        rm -rf -- "$archive_path" "$extract_dir"
        error "Failed to download Neovim from $archive_url"
        exit 1
    fi
}


install_dotfiles() {
    info "Installing dotfiles..."
    local private_dotfiles_dir="${DOTFILES_PRIVATE_DIR:-$HOME/work/dotfiles-private}"

    # https://github.com/sorin-ionescu/prezto
    link_files "$DOTFILES_DIR/zprezto" ~/.zprezto
    link_files "$DOTFILES_DIR/zprezto/runcoms/zlogin" ~/.zlogin
    link_files "$DOTFILES_DIR/zprezto/runcoms/zlogout" ~/.zlogout
    link_files "$DOTFILES_DIR/zprezto/runcoms/zprofile" ~/.zprofile
    link_files "$DOTFILES_DIR/zprezto/runcoms/zshenv" ~/.zshenv

    link_files "$DOTFILES_DIR/pyenv" ~/.pyenv
    link_files "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
    link_files "$DOTFILES_DIR/vimrc" ~/.vimrc
    link_files "$DOTFILES_DIR/vim" ~/.vim
    mkdir -p ~/.config/nvim
    link_files "$DOTFILES_DIR/nvim/init.vim" ~/.config/nvim/init.vim
    link_files "$DOTFILES_DIR/zshrc" ~/.zshrc
    link_files "$DOTFILES_DIR/zpreztorc" ~/.zpreztorc
    mkdir -p ~/.local/bin
    link_files "$DOTFILES_DIR/bin/md-preview-server" ~/.local/bin/md-preview-server
    mkdir -p ~/.codex/skills
    link_files "$DOTFILES_DIR/.agents/skills/cmux-markdown-preview" ~/.codex/skills/cmux-markdown-preview
    if [ -d "$private_dotfiles_dir" ]; then
        if [ -f "$private_dotfiles_dir/zshrc.local" ]; then
            link_files "$private_dotfiles_dir/zshrc.local" ~/.zshrc.local
        else
            warn "Private zsh overlay not found at $private_dotfiles_dir/zshrc.local. Skipping."
        fi
    fi
    mkdir -p ~/.ssh
    link_files "$DOTFILES_DIR/ssh/config" ~/.ssh/config
    if [ -d "$private_dotfiles_dir" ]; then
        if [ -f "$private_dotfiles_dir/ssh/config.local" ]; then
            link_files "$private_dotfiles_dir/ssh/config.local" ~/.ssh/config.local
        else
            warn "Private SSH overlay not found at $private_dotfiles_dir/ssh/config.local. Skipping."
        fi
    fi
    mkdir -p ~/.config/ghostty
    link_files "$DOTFILES_DIR/ghostty/config.ghostty" ~/.config/ghostty/config.ghostty
    link_files "$DOTFILES_DIR/ghostty/config.ghostty" ~/.config/ghostty/config

    # VS Code settings (macOS specific)
    if [[ "$(uname)" == "Darwin" ]]; then
        local vscode_dir="$HOME/Library/Application Support/Code/User"
        if [ -d "$vscode_dir" ]; then
            link_files "$DOTFILES_DIR/vscode/settings.json" "$vscode_dir/settings.json"
            link_files "$DOTFILES_DIR/vscode/keybindings.json" "$vscode_dir/keybindings.json"
            success "VS Code settings linked"
        else
            warn "VS Code directory not found. Skipping VS Code settings."
        fi
    else
        warn "Non-macOS system detected. Skipping VS Code settings."
    fi

    success "Dotfiles installation completed"
}

main() {
    info "Starting dotfiles installation..."

    check_dependencies
    check_os_compatibility
    setup_git_submodule
    install_dotfiles
    install_neovim

    if [ ! -e "$HOME/.deno/bin/deno" ]; then
        install_deno
    fi
}

if [[ -z "${DOTFILES_SOURCE_ONLY:-}" && "${${(%):-%N}:A}" == "${0:A}" ]]; then
    main "$@"
fi
