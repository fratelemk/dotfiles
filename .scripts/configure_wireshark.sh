#!/bin/bash

groupadd wireshark
usermod -aG wireshark $USER
chgrp wireshark /usr/bin/dumpcap
chmod o-rx /usr/bin/dumpcap

setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap
getcap /usr/bin/dumpcap

