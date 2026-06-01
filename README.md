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

> [!TIP]
> Use `systemd-analyze cat-config systemd/timesyncd.conf` to display the full `timesyncd` config.

- LinkNTPServers= — per-interface NTP from DHCP (option 42), pushed by `systemd-networkd`.

- SystemNTPServers= — static config from /etc/systemd/timesyncd.conf.

- RuntimeNTPServers= — runtime-injected, via `timedatectl set-ntp-servers`.

- FallbackNTPServers=0.debian.pool.ntp.org ... — last resort, used ONLY when all above empty. Comes from defaults in /etc/systemd/timesyncd.conf. 

- ServerName=2.debian.pool.ntp.org — server timesyncd CURRENTLY synced to.
ServerAddress=31.14.41.138 — resolved IP of that server, active connection right now.


#### NetworkManager Dispatcher Hook

**Location:** `/etc/NetworkManager/dispatcher.d/50-timesyncd`

**Example:**

```bash
#!/bin/sh
set -v
echo args: $@

[ -z "$CONNECTION_UUID" ] && exit 0
INTERFACE="$1"
ACTION="$2"

case $ACTION in
up | dhcp4-change | dhcp6-change)
	[ -n "$DHCP4_NTP_SERVERS" ] || exit
	mkdir -p /etc/systemd/timesyncd.conf.d
	cat <<-THE_END >"/etc/systemd/timesyncd.conf.d/${CONNECTION_UUID}.conf"
		[Time]
		NTP=$DHCP4_NTP_SERVERS
	THE_END
	systemctl restart systemd-timesyncd.service
	;;
down)
	rm -f "/etc/systemd/timesyncd.conf.d/${CONNECTION_UUID}.conf"
	systemctl restart systemd-timesyncd.service
	;;
esac
```

**Reference:** [Dynamically set NTP servers received via DHCP](https://wiki.archlinux.org/title/NetworkManager#Dynamically_set_NTP_servers_received_via_DHCP_with_systemd-timesyncd)

#### systemd-network

Set directly in `/etc/systemd/network/xx.network`:

```ini
[Network]
DHCP=yes
[DHCP]
UseNTP=yes
```

**Reference:** see `man systemd.network`
