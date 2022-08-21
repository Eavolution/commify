#! /bin/bash
# True iff all arguments are executable in $PATH
function is_bin_in_path {
  if [[ -n $ZSH_VERSION ]]; then
    builtin whence -p "$1" &> /dev/null
  else  # bash:
    builtin type -P "$1" &> /dev/null
  fi
  [[ $? -ne 0 ]] && return 1
  if [[ $# -gt 1 ]]; then
    shift  # We've just checked the first one
    is_bin_in_path "$@"
  fi
}

function install_stack {
    if (!(is_bin_in_path "curl")); then
        echo "Curl required. Please install curl from your package manager."
        exit
    else
        curl -sSL https://get.haskellstack.org/ | bash
    fi
}

function main {
    if (!(is_bin_in_path "stack")); then
        while true
            do
            echo "Stack was not found in the PATH. Would you like to install stack? [Y/N]"
            read choice
            case $choice in
                [yY][eE][sS]|[yY])
                    echo "Installing stack"
                    install_stack
                    stack setup
                    break;;

                [nN][oO]|[nN])
                    echo "Ending"
                    exit
                    break;;
                *)
                    echo "Invalid choice"
                    ;;
            esac
        done
        else
            stack install
            mv ./build/commify-exe ./build/commify
    fi
}

main