export interface SyntaxColor {
  foreground: string
  comment: string
  string: string
  keyword: string
  constant: string
  function: string
  type: string
  invalid: string
  punctuation: string
  quote: string
  insertedBg: string
  deletedBg: string
  changedBg: string
  rawBg: string
  lineHighlightBg: string
  findMatchBg: string
  findMatchHighlightBg: string
  wordHighlightBg: string
  brightRed: string
  brightGreen: string
  brightYellow: string
  brightBlue: string
  brightMagenta: string
  brightCyan: string
  green: string
  white: string
}

export interface BasicColor {
  primary: string
  editor: string
  selection: string
  text: string
  shadow: string
  inactive: string
  hint: string
  error: string
  syntax: SyntaxColor
}

// Acme terminal palette as xterm-256 indices
// (vacme / raphael-proust.github.io/code/acme-theme.html),
// mapped onto the token roles of VS Code's Light 2026 default theme.
const vacmeSyntax: SyntaxColor = {
  foreground: "#444444",           // 238
  comment: "#AFAF87",              // 144
  string: "#5FAFAF",               // 73
  keyword: "#D75F5F",              // 167
  constant: "#0087D7",             // 32
  function: "#8787D7",             // 104
  type: "#AFAF5F",                 // 143
  invalid: "#D75F5F",              // 167
  punctuation: "#444444",          // 238
  quote: "#87D7AF",                // 116
  insertedBg: "#D7FFD7",           // 194
  deletedBg: "#FFD7D7",            // 224
  changedBg: "#D7D7FF",            // 189
  rawBg: "#D7D7AF",                // 187
  lineHighlightBg: "#FFFFD7",      // 230
  findMatchBg: "#D7D787",          // 186
  findMatchHighlightBg: "#D7D7AF", // 187
  wordHighlightBg: "#D7D7FF",      // 189
  brightRed: "#FFAFAF",            // 217
  brightGreen: "#D7FFD7",          // 194
  brightYellow: "#D7D787",         // 186
  brightBlue: "#87D7FF",           // 117
  brightMagenta: "#D7D7FF",        // 189
  brightCyan: "#D7FFFF",           // 195
  green: "#87D7AF",                // 116
  white: "#FFFFD7",                // 230
}

export const goPlaygroundColors: BasicColor = {
  primary: "#FFFFDD",
  editor: "#FFFFDD",
  selection: "#B2D7F0",
  text: "#000000",
  shadow: "#99994c",
  inactive: "#D4D4C6",
  hint: "#8888cc",
  error: "#db6165",
  syntax: vacmeSyntax,
}

export const goSourceColors: BasicColor = {
  primary: "#EFEFEF",
  editor: "#EFEFEF",
  selection: "#B2D7F0",
  text: "#000000",
  shadow: "#D4D4C6",
  inactive: "#D4D4C6",
  hint: "#8888cc",
  error: "#db6165",
  syntax: vacmeSyntax,
}

export const acmeColors: BasicColor = {
  primary: "#eaffff",
  editor: "#ffffea",
  selection: "#eeee9e",
  text: "#000000",
  shadow: "#99994c",
  inactive: "#eeee9e",
  hint: "#8888cc",
  error: "#db6165",
  syntax: vacmeSyntax,
}

export function getColors(theme: string): BasicColor {
  switch (theme) {
    case "acme":
      return acmeColors;
    case "go-playground":
      return goPlaygroundColors;
    case "go-source":
      return goSourceColors;
    default:
      throw new Error(`Colors are missing for value: ${theme}`);
  }
}
