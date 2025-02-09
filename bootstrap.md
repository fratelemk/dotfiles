# i3

### Remove Packages

`dnf remove Thunar xfce-terminal volumeicon mousepad && rm -rf ~/.config/xfce4`

### Disable Printing
`dnf remove cups system-config-printer* ghostscript-tools-printing gutenprint && rm -rf /etc/cups /var/cache/cups /usr/lib/cups /usr/share/cups && sudo semodule -X 100 -r cups`

### GTK Dark Mode
```
cat << EOF | tee ~/.config/gtk-3.0/settings.ini > /dev/null
[Settings]
gtk-application-prefer-dark-theme=1
EOF
```

### Install Brave Browser
```
sudo dnf install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-browser
```

---

# Server

### Jupyter Lab 
[Reference](https://jupyterhub.readthedocs.io/en/1.2.2/installation-guide-hard.html)
```
sudo python3 -m venv /opt/jupyterlab/
sudo /opt/jupyterhub/bin/python3 -m pip install --upgrade pip
sudo /opt/jupyterhub/bin/python3 -m pip install wheel jupyterlab jupyterlab-git jupyterlab-vim ipywidgets 
```
    
```
cat << EOF | tee ~/.config/systemd/user/jupyter.service > /dev/null
[Unit]
Description=Jupyter Lab
After=network.target

[Service]
Type=simple
User=jupyter
Group=jupyter
WorkingDirectory=/home/jupyter
ExecStart=/opt/jupyterlab/bin/jupyter lab --ip=127.0.0.1 --port=8888 --no-browser
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### mDNS

`sudo dnf install avahi nss-mdns`

### NodeJS

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 22
```

### NodeRED

`sudo npm install -g --unsafe-perm node-red`
```
cat << EOF | tee ~/.config/systemd/user/node-red.service > /dev/null
[Unit]
Description=Node-RED is a tool for wiring together hardware devices, APIs and online services in new and interesting ways
After=syslog.target network.target
Documentation=https://nodered.org/docs/

[Service]
ExecStart=/usr/bin/env node-red
WorkingDirectory=/home/node-red
User=node-red
Group=node-red
Nice=10
StandardOutput=journal
StandardError=journal
Restart=on-failure
KillSignal=SIGINT
Environment=NODE_OPTIONS=--max_old_space_size=256
MemoryLimit=512M

[Install]
WantedBy=multi-user.target
EOF
```
