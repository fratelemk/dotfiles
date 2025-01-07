# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mflorescu/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mflorescu/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/mflorescu/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mflorescu/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

function register_conda_kernel() {
  # 1) Ensure we are in a valid conda environment
  if [ -z "$CONDA_DEFAULT_ENV" ]; then
    echo "No conda environment detected. Please 'conda activate <env>' first."
    return 1
  fi

  # 2) Get the environment name and its kernel directory
  local env_name="$CONDA_DEFAULT_ENV"
  local kernel_dir="$HOME/.local/share/jupyter/kernels/$env_name"

  # 3) If the kernel directory already exists, skip
  if [ -d "$kernel_dir" ]; then
    echo "A Jupyter kernel named '$env_name' is already registered in:"
    echo "  $kernel_dir"
    echo "Skipping registration."
    return 0
  fi

  # 4) Ensure ipykernel is installed in the current environment
  conda install ipykernel -y

  # 5) Get the Python version from the active environment
  local py_version
  py_version=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")')

  # 6) Register the new kernel with a friendly display name
  python -m ipykernel install --user \
    --name "$env_name" \
    --display-name "Python $py_version | packaged by conda-forge ($env_name)"
}
