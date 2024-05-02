#!/bin/bash
INSTALL_DIR=~/.git_bash
INIT_SCRIPT=~/.bash_profile

# Validates the installation of Git Bash.
#
# This function checks if the Git Bash installation directory exists and if the 
# initialization file exists within the installation directory. If both conditions 
# are met, it prints a message indicating that Git Bash is already installed 
# and exits with a status code of 1.
validate_installation() {
    if grep -q "# gitbash_install" "$INIT_SCRIPT" ; then
        echo "git bash manager is already installed"
        exit 1
    fi
}

# Install Git Bash.
#
# This function installs Git Bash by performing the following steps:
# 1. Validates the installation of Git Bash using the validate_installation function.
# 2. Downloads the Git Bash archive from the specified URL.
# 3. Extracts the contents of the downloaded archive to the home directory.
# 4. Moves the extracted directory to the specified installation directory.
# 5. Adds an initialization script to the specified initialization script file.
#
install() {
    validate_installation
    TMP_FILE=$(mktemp)
    echo "[.git_bash][Downloading git_bash manager archive from github]"
    curl https://github.com/sergio-rodrigues/.git_bash/archive/refs/heads/main.zip -o "$TMP_FILE.zip"
    echo "[.git_bash][Extracting]"
    unzip $TMP_FILE -d ~
    rm "$TMP_FILE.zip"
    mv ~/.git_bash-main $INSTALL_DIR
    echo "[.git_bash][Adding init script to $INIT_SCRIPT]"
    cat <<EOF >> $INIT_SCRIPT

# gitbash_install
if [ -f $INSTALL_DIR/.init_git_bash ]; then
    . $INSTALL_DIR/.init_git_bash
    alias git_bash_manager='$INSTALL_DIR/.install/git_bash_manager.sh'
fi
# /gitbash_install
EOF
    echo "[.git_bash][Done]"
}

#Uninstalls Git Bash from the system.
#
# This function checks if Git Bash is installed by verifying the existence of the
# installation directory and the initialization file. If Git Bash is not installed,
# it prints a message and exits with a status code of 1. Otherwise, it removes the
# installation directory and removes the initialization script from the specified
# initialization script file.
uninstall() {
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Git bash is not installed"
        exit 1
    fi
    rm -rf $INSTALL_DIR
    sed -i '/# gitbash_install/,/# \/gitbash_install/d' $INIT_SCRIPT
}

if [ ! -t 0 ] || [ "$1" = "install" ]; then
    install
elif [ "$1" = "uninstall" ]; then
    uninstall
else
    echo "usage: $0 [install|uninstall]"
fi