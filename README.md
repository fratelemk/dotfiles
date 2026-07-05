## macOS Bootstrap

Enable 'Remote Login':

```sh
sudo systemsetup -setremotelogin on
```
Install 'Xcode Command Line Tools':

```sh
xcode-select --install
```

Enable `locate` database:

```sh
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
```

Enable `pip`:

#### Method 1 - System

```sh
python3 -m ensurepip --upgrade
```

#### Method 2 - Homebrew

```sh
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"
sudo pip3 install --upgrade pip
```


## macOS Settings

1. Disable `Widgets` both `On Desktop` & `In Stage Manager`      
      
      `Settings` -> `Desktop & Dock` -> `Show Widgets`       

2. Change `Click wallpaper to show desktop` from `Always` to `Only in Stage Manager`

3. Disable `Help Apple Improve Search`

   `Settings` -> `Spotlight`

4. Disable `Slightly dim the display on battery`

   `Settings` -> `Battery` -> `Options`

5. Enable `Firewall`

6. Disable `Notifications`

    - Game Center
    - Tips

7. Optimise Storage

   `Settings` -> `General` -> `Storage` -> `Store in iCloud` / `Empty Bin automatically`

8. Sign Out of Game Center

9. Show Path Bar

   `Finder` -> `View` -> `Show Path Bar`

---

## SSH Keys

```bash
ssh-keygen -t ed25519 -N "" -C ""

eval "$(ssh-agent -s)"

cat << 'EOF' >> ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF

ssh-add ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub
```

---

## VIM

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

---

## ZSH

[autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

```bash
mkdir -p "$HOME/.local/zsh"

git clone --depth 1 \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$HOME/.local/share/zsh-syntax-highlighting"

git clone --depth 1 \
  https://github.com/zsh-users/zsh-autosuggestions.git \
  "$HOME/.local/share/zsh-autosuggestions"

cat <<'EOF' >> "$HOME/.zshrc"
source $HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF
```

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

## Command Reference

Force update `locate` database:

```sh
sudo /usr/libexec/locate.updatedb
```
