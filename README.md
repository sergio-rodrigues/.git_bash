# About
The Git for Windows package offers a versatile Linux-like environment, this script can be used to provide developers set of tools that allows them to organize their workflow and development environment on Windows platforms.

Since this environment supports the execution of scripts intended for Linux systems, is particularly beneficial for executing shell scripts, editing configurations, and managing projects, all within the familiar confines of Windows.

Moreover, it enables the running of several Linux commands directly, eliminating the need for a Virtual Machine (VM) or the Windows Subsystem for Linux (WSL). 

This streamlined setup allows developers to maintain a Linux-like development environment on their Windows machines, offering the flexibility and power of Linux without the overhead of additional virtualization layers. 

## Automatic Installation
Execute the automatic instalation script directly from the web:

```bash
curl -s -L https://raw.githubusercontent.com/sergio-rodrigues/.git_bash/main/.install/git_bash_manager.sh | sh
```

> CAREFULL:
>
> - You should not install scripts directly from the web without knowing what they do.
> - You should always read their source and understand what they do.

## Manual Installation
Manual installation of software, though more time-consuming than the automated script, provides a deeper understanding of the system's workings and a greater control over the setup process. This method facilitates customization and troubleshooting, allowing a configuration that aligns precisely with the user's needs. It's particularly advantageous for those seeking to enhance their technical knowledge or require specific system configurations.

### Step 1: Download the repository zip file
Download the zip file from github:

```bash
curl https://github.com/sergio-rodrigues/.git_bash/archive/refs/heads/main.zip -o git_bash.zip
```

### Step 2: Extract the zip file to your home directory
Extract the zip file to your home directory

```bash
unzip git_bash -d ~
```

### Step 3: make sure the directory is correctly named
Make sure the directory is named .git_bash, because the zip file from github includes the branch name: 

```bash
mv ~/.git_bash-master ~/.git_bash
```

### Step 4: Add the init script to shell startup
Add the following lines to a shell startup script file like `.bash_profile`:

```bash
if [ -f ~/.git_bash/.init_git_bash ]; then
    . ~/.git_bash/.init_git_bash
fi
```

You can copy/past the following command to the terminal to add the script to `.bash_profile`

```bash
cat <<EOF
if [ -f ~/.git_bash/.init_git_bash ]; then
    . ~/.git_bash/.init_git_bash
fi
EOF >> ~/.bash_profile
```