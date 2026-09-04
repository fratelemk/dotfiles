# Installing LMStudio on Rocky 10

Download & Install LMStudio
```bash
curl -fsSL https://lmstudio.ai/install.sh | bash
```

Configure User & Environment
```bash
useradd -d /home/llmster -s /bin/bash llmster
passwd -l llmster

mkdir -p /home/llmster/.config/systemd/user
mkdir -p /home/llmster/.local/bin
ln -s /home/llmster/.lmstudio/bin/lms ~/.local/bin/lms
```

Configure Service
```
tee /home/llmster/.config/systemd/user/lmstudio.service > /dev/null <<'EOF'
[Unit]
Description=LM Studio Server

[Service]
Type=oneshot
RemainAfterExit=yes
Environment="HOME=/home/llmster"
ExecStartPre=/home/llmster/.local/bin/lms daemon up
ExecStart=/home/llmster/.local/bin/lms server start --bind 0.0.0.0
ExecStop=/home/llmster/.local/bin/lms daemon down

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now lmstudio.service
loginctl enable-linger llmster
```
