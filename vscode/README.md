# themes-go-acme

Light VS Code themes in the spirit of Plan 9 / Acme and the Go Playground:
**Acme**, **Go - Playground**, **Go - Source**.

Syntax colours use the acme xterm-256 terminal palette (vacme), mapped onto
the token roles of VS Code's Light 2026 default theme. Comments are bold,
variables stay plain, values get quiet inks.

## Develop

Theme JSON files in `themes/` are generated — edit the sources instead:

- `src/color.ts` — palettes (UI colours per theme, shared syntax palette)
- `src/theme.ts` — maps colours to VS Code theme keys and TextMate scopes
- `src/index.ts` — writes `themes/*.json`

Regenerate after changes:

```sh
npm run build
```

Preview: open this folder in VS Code, press `F5` (launches an Extension
Development Host with the themes loaded), then `Cmd+K Cmd+T` to pick one.

## Package & install

```sh
npx -y @vscode/vsce package --no-dependencies -o build/themes-go-acme.vsix
code --install-extension build/themes-go-acme.vsix
```

Installs locally, no marketplace account needed. Reload VS Code, then
`Cmd+K Cmd+T` to select the theme.

Note: the title bar colour needs `"window.titleBarStyle": "custom"`.

## References

- http://acme.cat-v.org
- https://github.com/overvale/vacme
- https://raphael-proust.github.io/code/acme-theme.html
- https://github.com/lunacookies/vim-plan9
