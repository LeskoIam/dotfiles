#!/usr/bin/env bash

[[ "$1" == "-v" ]] && VERBOSE=true


log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo " [DEBUG] $1"
    fi
}

update-fzf() {
    #######################
    # Run download and all in a temp directory, so if anything fails 
    # it will get removed on function exit
    local TMP_DIR
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR" || return
    #######################

    echo "Checking for the latest fzf release..."
    local LATEST_VERSION
    LATEST_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_VERSION" ]; then
        echo "Error: Could not fetch latest version."
        return 1
    fi

    # Get current local version
    local CURRENT_VERSION
    if command -v fzf >/dev/null 2>&1; then
        CURRENT_VERSION=$(fzf --version | awk '{print $1}')
    else
        CURRENT_VERSION="none"
    fi
    
    # Compare versions 
    # strip 'v' prefix if it exists
    if [[ "${LATEST_VERSION#v}" == "${CURRENT_VERSION#v}" ]]; then
        echo "fzf is already up to date ($CURRENT_VERSION)."
        return 0
    fi

    echo "Current local version: $CURRENT_VERSION"
    echo "Updating to: $LATEST_VERSION"
    
    local OS
    local ARCH
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    [[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
    [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]] && ARCH="arm64"
    
    log "os: $OS"
    log "architecture: $ARCH"
    
    local FILENAME="fzf-${LATEST_VERSION#v}-${OS}_${ARCH}.tar.gz"
    local URL="https://github.com/junegunn/fzf/releases/download/${LATEST_VERSION}/${FILENAME}"
    log "filename: $FILENAME"
    log "url: $URL"
    
    # Download, extract, and move
    curl -LO "$URL"
    tar -xzf "$FILENAME"
    sudo mv fzf /usr/local/bin/
    rm "$FILENAME"

    echo "Successfully updated fzf to $(fzf --version)"
    #######################
    cd - || exit
    rm -rf "$TMP_DIR"
    #######################
}

update-fzf

