# Ruby

## Command Reference

### 1. Create project

```sh
mkdir my_app && cd my_app
bundle init
```

### 2. Add gems (packages)

```sh
bundle add <package>
```

### 3. Run

```sh
bundle exec ruby main.rb
```

## CLI Reference

```sh
bundle install         # install from Gemfile
bundle add NAME        # add gem + install
bundle update NAME     # bump one gem, update lock
bundle outdated        # list stale gems
bundle exec CMD        # run inside locked gem set
```

## Environment Setup

### 1. Clone `rbenv` + `ruby-build`

```sh
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

### 2. Shell Setup

```sh
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc

rbenv --version
type rbenv
```

### 4. Build `libyaml`

```sh
curl -LO https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz
tar xzf yaml-0.2.5.tar.gz
cd yaml-0.2.5
./configure --prefix="$HOME/.local/libyaml"
make
make install
cd ..
```

### 5. Install Ruby

```sh
RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$HOME/.local/libyaml" rbenv install 4.0.6
rbenv global 4.0.6
```

### 6. Verify Ruby

```sh
ruby --version
which ruby
ruby -ryaml -e 'puts YAML.dump(ok: true)'
```

# Python

```bash
python3.13 -m pip install --upgrade pip
python3.13 -m pip install certifi

sudo mkdir -p /Library/Frameworks/Python.framework/Versions/3.13/etc/openssl
sudo ln -sf "$(python3.13 -c 'import certifi; print(certifi.where())')" \\n  /Library/Frameworks/Python.framework/Versions/3.13/etc/openssl/cert.pem

python3.13 -c "import ssl; print(ssl.get_default_verify_paths())"
```

# Java

```bash
git clone --depth 1 https://github.com/jenv/jenv.git ~/.jenv

echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc

curl -LO https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz

tar -xzf amazon-corretto*
rm *.tar.gz

mv amazon-corretto* /Library/Java/JavaVirtualMachines

jenv add /Library/Java/JavaVirtualMachines/amazon-corretto*/Contents/Home

jenv global 17

ln -s ~/.local/share/maven/bin/mvn ~/.local/bin/mvn
export MAVEN_HOME="$HOME/.local/share/maven"
```

# AWS

### 1. AWS CLI

```bash
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | sudo bash -s -- --system
```

### 2. AWS Session Manager

```bash
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"

unzip sessionmanager-bundle.zip

sudo /usr/local/bin/python3.13 sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```
