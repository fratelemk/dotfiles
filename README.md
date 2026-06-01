# Raspberry Pi Bootstrap

1. Disable WiFi/Bluetooth at firmware level
2. Install packages, disable radio connections in `NetworkManager` and `wpa_supplicant` service
3. Blacklist `spi` & `i2c` kernel modules
4. Configure network interfaces

### Update

```bash
sudo apt update
sudo rpi-eeprom-update -a
sudo rpi-update
```

**Services**
- [Tinyproxy](https://tinyproxy.github.io/) - HTTP/S Proxy
  
  Installation
  ```bash
  apt install tinyproxy
  ```
  
- [Pi-hole](https://pi-hole.net/) - DNS Sinkhole & DHCP/NTP Server

  Installation
  ```bash
  curl -sSL https://install.pi-hole.net | bash
  ```

## Pi-hole

### NTP

#### Troubleshooting

```bash
timedatectl status

timedatectl show-timesync --all | grep Server
```

```bash
nc -vzu 127.0.0.1 123
```

```bash
apt install ntpsec-ntpdate
ntpdate -q 127.0.0.1
```

```bash
apt install ntpsec-ntpdig
sntp 127.0.0.1
```
