# NVIDIA Driver Installation Guide on Rocky 10

## Preparation

The kernel headers and development packages for the currently running kernel can be installed with:
```bash
dnf install kernel-devel-matched kernel-headers -y
```

Satisfy third-party package dependencies:
```bash
dnf config-manager --set-enabled crb
dnf install epel-release -y
dnf groupinstall "Development Tools" -y
```

Enable the network repository:
```bash
dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel10/$(uname -m)/cuda-rhel10.repo
dnf clean expire-cache
```

Driver installation:
```bash
dnf install nvidia-open -y
dnf install nvidia-driver-cuda kmod-nvidia-open-dkms -y
```

Disable Nouveau:
```bash
grubby --args="nouveau.modeset=0 rd.driver.blacklist=nouveau" --update-kernel=ALL
reboot  
```

## Tuning

Check the current mitigation status:
```bash
grep . /sys/devices/system/cpu/vulnerabilities/*
```

```bash
dnf install -y https://repo.download.nvidia.com/baseos/el/el-files/10/nvidia-repositories-25.09-5.el10.x86_64.rpm
dnf install -y https://repo.download.nvidia.com/baseos/el/el-files/10/dgx-repositories-25.09-2.el10.x86_64.rpm
dnf update -y
dnf install tuned -y
dnf group install -y "NVIDIA System Core"
```

**References**
- https://github.com/ggml-org/llama.cpp/issues/2251
- https://docs.nvidia.com/dgx/dgx-el10-user-guide/modifying-tuned.html#creating-a-custom-profile-from-scratch
- https://docs.nvidia.com/dgx/dgx-el10-user-guide/installing_dgx_software.html#configuring-a-system-proxy
- https://github.com/ggml-org/llama.cpp/issues/12444

## BIOS Settings

- Disable Audio
- Disable SATA Controller
- Clear Secure Boot Keys
- Set Secure Boot to Other OS
- Disable CSM
- Disable Hyperthreading
