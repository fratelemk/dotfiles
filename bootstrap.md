## ZSH

### [autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
`git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.local/zsh/zsh-autosuggestions`

### [syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/zsh/zsh-syntax-highlighting`

### [completions](https://github.com/zsh-users/zsh-completions)
`git clone https://github.com/zsh-users/zsh-completions.git ~/.local/zsh/zsh-completions`

---

## [NodeJS](https://nodejs.org/en)

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 22
```

---

## Java

[Download a JDK](https://learn.microsoft.com/en-us/java/openjdk/download)

Move downloaded JDK to `/Library/Java/JavaVirtualMachines/`

---

## [Conda](https://www.anaconda.com/docs/getting-started/miniconda/main)

```
mkdir -p ~/Library/Conda
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/Library/Conda/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/Library/Conda
rm ~/Library/Conda/miniconda.sh

~/Library/Conda/bin/conda init zsh

git clone https://github.com/conda-incubator/conda-zsh-completion ~/.local/zsh/conda-zsh-completion
```
