### Jupyter

List currently installed kernels
`jupyter kernelspec list`

Install a kernel

Default location is `$HOME/.local/share/jupyter/kernels/<name>`

`python -m ipykernel install --user --name <name> --display-name <display-name>`

Remove a kernel
`jupyter kernelspec remove <name>`

---

### RPM

Check for a package's config files
`rpm -q --configfiles <package_name>`

Check for a package
`rpm -qa`
