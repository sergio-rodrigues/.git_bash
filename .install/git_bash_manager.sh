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
    if [ "${1}" = ".git_bash" ]; then
        if grep -q "# gitbash_install" "$INIT_SCRIPT" ; then
            echo "[.git_bash][Git bash manager is already installed]"
            exit 1
        fi
    else
        if [ -d "$INSTALL_DIR/${1}" ]; then
            echo "[.git_bash][Module ${1} is already installed]"
            exit 1
        fi;
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
install() {
    module="${1:-.git_bash}"
    if [[ ! ${module} =~ ^\.git_.* ]]; then
        echo "Module name must start with '.git_'"
        exit 1
    fi
    validate_installation "${module}"
    
    TMP_DIR=$(mktemp -d) || exit 1; 
    TMP_FILE="${TMP_DIR}/${module}"
    echo "[.git_bash][Downloading ${module} archive from github]"
    curl "https://codeload.github.com/sergio-rodrigues/${module}/zip/refs/heads/main" -o "$TMP_FILE.zip"
    echo "[.git_bash][Extracting ${module}]"
    unzip "${TMP_FILE}" -d "${TMP_DIR}"
    if [ "${module}" = ".git_bash" ]; then
        mv "${TMP_DIR}/${module}-main" ${INSTALL_DIR} || exit 1;        
        mkdir -p ${INSTALL_DIR}/.scripts
        echo "[.git_bash][Adding init script to ${INIT_SCRIPT}]"
        cat <<EOF >> "${INIT_SCRIPT}"

# gitbash_install
if [ -f ${INSTALL_DIR}/.init_git_bash ]; then
    . ${INSTALL_DIR}/.init_git_bash
    alias git_bash_manager='${INSTALL_DIR}/.install/git_bash_manager.sh'
fi
# /gitbash_install
EOF
    else
        mv "${TMP_FILE}-main" "${INSTALL_DIR}/${module}"
        cp "${INSTALL_DIR}/.install/.scripts/${module#.}" "${INSTALL_DIR}/.scripts/"
    fi

    rm "${TMP_FILE}.zip"
    rm -rf "${TMP_DIR}"
    echo "[.git_bash][Done]"
}

# Uninstalls Git Bash from the system.
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
    install "$2"
elif [ "$1" = "uninstall" ]; then
    uninstall
else
    echo "usage: $0 [install|uninstall]"
fi