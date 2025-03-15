### Jupyter

List currently installed kernels

`jupyter kernelspec list`

Install a kernel

[Default location on Linux is `$HOME/.local/share/jupyter/kernels/<name>`]: #

`python -m ipykernel install --user --name <name> --display-name <display-name>`

Remove a kernel

`jupyter kernelspec remove <name>`

---

### RPM

Check for a package's config files

`rpm -q --configfiles <package_name>`

Check for a package

`rpm -qa`

---

### NetworkManager

Check for *autoconnect*

`nmcli -f name,autoconnect connection`

Disable *autocconect*

`nmcli con mod <con-name> connection.autoconnect no`
