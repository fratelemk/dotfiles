## ZSH

### autosuggestions
`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/zsh/zsh-autosuggestions`

### syntax-highlighting
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/zsh/zsh-syntax-highlighting`

---

## NodeJS

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 22
```

---

## Java

[Download a JDK](https://learn.microsoft.com/en-us/java/openjdk/download)

Move the JDK to `/Library/Java/JavaVirtualMachines/

---

## Conda

mkdir -p ~/Library/Conda
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/Library/Conda/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/Library/Conda
rm ~/Library/Conda/miniconda.sh

~/Library/Conda/bin/conda init zsh
