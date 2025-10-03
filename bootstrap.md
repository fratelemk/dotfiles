## ZSH

### [autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
`git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.local/zsh/zsh-autosuggestions`

### [syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/zsh/zsh-syntax-highlighting`

### [completions](https://github.com/zsh-users/zsh-completions)
`git clone https://github.com/zsh-users/zsh-completions.git ~/.local/zsh/zsh-completions`

---

## [NodeJS](https://nodejs.org/en)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 22
```

---

## Java

[Download a JDK](https://learn.microsoft.com/en-us/java/openjdk/download)

Move downloaded JDK to `/Library/Java/JavaVirtualMachines/`

---

## [Conda](https://www.anaconda.com/docs/getting-started/miniconda/main)

```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
bash ~/miniconda3/miniconda.sh -b -p ~/Library/Conda -c

conda update -n base -c defaults conda

conda config --set auto_activate_base false

git clone https://github.com/conda-incubator/conda-zsh-completion ~/.local/zsh/conda-zsh-completion
```

# Defaults

```bash
# Dock

defaults write com.apple.dock autohide -bool true

```
