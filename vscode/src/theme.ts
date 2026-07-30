import { getColors  } from "./color.ts"

export default function getTheme({ theme, name }: { theme: string; name: string }): Object {

  const colors = getColors(theme)

  return {
    "name": name,
    "type": "light",
    "colors": {
      "activityBar.background": colors.primary,
      "activityBar.border": colors.text,
      "activityBar.dropBackground": colors.shadow,
      "activityBar.foreground": colors.text,
      "activityBarBadge.background": colors.hint,
      "activityBarBadge.foreground": colors.text,
      "badge.background": colors.hint,
      "badge.foreground": colors.text,
      "button.background": colors.primary,
      "button.foreground": colors.text,
      "editor.background": colors.editor,
      "editor.foreground": colors.syntax.foreground,
      "editor.hoverHighlightBackground": colors.editor,
      "editor.inactiveSelectionBackground": colors.inactive,
      "editor.selectionBackground": colors.selection,
      "editor.selectionHighlightBackground": colors.selection,
      "editor.lineHighlightBackground": colors.syntax.lineHighlightBg,
      "editor.findMatchBackground": colors.syntax.findMatchBg,
      "editor.findMatchHighlightBackground": colors.syntax.findMatchHighlightBg,
      "editor.wordHighlightBackground": colors.syntax.wordHighlightBg,
      "diffEditor.insertedTextBackground": colors.syntax.insertedBg,
      "diffEditor.removedTextBackground": colors.syntax.deletedBg,
      "editorGroupHeader.tabsBackground": colors.primary,
      "input.background": colors.primary,
      "input.border": colors.text,
      "input.foreground": colors.text,
      "input.placeholderForeground": colors.text,
      "panel.background": colors.editor,
      "selection.background": colors.editor,
      "sideBar.dropBackground": colors.shadow,
      "sideBar.background": colors.primary,
      "sideBar.border": colors.text,
      "sideBarSectionHeader.background": colors.primary,
      "sideBar.foreground": colors.text,
      "scrollbarSlider.activeBackground": colors.shadow,
      "scrollbarSlider.background": colors.shadow,
      "scrollbarSlider.hoverBackground": colors.shadow,
      "titleBar.activeBackground": colors.syntax.string,
      "titleBar.activeForeground": colors.syntax.white,
      "titleBar.inactiveBackground": colors.syntax.brightCyan,
      "titleBar.inactiveForeground": colors.syntax.foreground,
      "titleBar.border": colors.text,
      "statusBar.background": colors.primary,
      "statusBar.border": colors.text,
      "statusBar.foreground": colors.text,
      "tab.activeBackground": colors.primary,
      "tab.activeBorder": colors.text,
      "tab.activeBorderTop": colors.primary,
      "tab.activeForeground": colors.text,
      "tab.inactiveBackground": colors.primary,
      "tab.border": colors.primary,
      "tab.hoverBackground": colors.editor,
      "tab.hoverBorder": colors.primary,
      "tab.inactiveForeground": colors.text,
      "list.focusHighlightForeground": colors.primary,
      "quickInputList.focusForeground": colors.primary,
      "editorSuggestWidget.selectedForeground": colors.primary,
      "editorBracketHighlight.foreground1": colors.text,
      "editorBracketHighlight.foreground2": colors.text,
      "editorBracketHighlight.foreground3": colors.text,
      "editorBracketHighlight.foreground4": colors.text,
      "editorBracketHighlight.foreground5": colors.text,
      "editorBracketHighlight.foreground6": colors.text,
      "editorBracketHighlight.unexpectedBracket.foreground": colors.error,
      "terminal.foreground": colors.syntax.foreground,
      "terminal.background": colors.editor,
      "terminal.ansiBlack": colors.syntax.foreground,
      "terminal.ansiRed": colors.syntax.keyword,
      "terminal.ansiGreen": colors.syntax.green,
      "terminal.ansiYellow": colors.syntax.type,
      "terminal.ansiBlue": colors.syntax.constant,
      "terminal.ansiMagenta": colors.syntax.function,
      "terminal.ansiCyan": colors.syntax.string,
      "terminal.ansiWhite": colors.syntax.white,
      "terminal.ansiBrightBlack": colors.syntax.comment,
      "terminal.ansiBrightRed": colors.syntax.brightRed,
      "terminal.ansiBrightGreen": colors.syntax.brightGreen,
      "terminal.ansiBrightYellow": colors.syntax.brightYellow,
      "terminal.ansiBrightBlue": colors.syntax.brightBlue,
      "terminal.ansiBrightMagenta": colors.syntax.brightMagenta,
      "terminal.ansiBrightCyan": colors.syntax.brightCyan,
      "terminal.ansiBrightWhite": colors.syntax.white
    },
    // Syntax colours: acme xterm-256 palette mapped onto the token roles
    // of VS Code's Light 2026 default theme. Comments stay bold (acme).
    "tokenColors": [
      {
        "name": "Comments",
        "scope": ["comment", "punctuation.definition.comment", "string.comment"],
        "settings": {
          "foreground": colors.syntax.comment,
          "fontStyle": "bold"
        }
      },
      {
        "name": "Docstrings",
        "scope": ["string.quoted.docstring"],
        "settings": {
          "foreground": colors.syntax.string,
          "fontStyle": "italic"
        }
      },
      {
        "name": "Keywords and storage",
        "scope": ["keyword", "storage", "storage.type"],
        "settings": {
          "foreground": colors.syntax.keyword
        }
      },
      {
        "name": "Import keywords stay plain",
        "scope": [
          "storage.modifier.package",
          "storage.modifier.import",
          "storage.type.java"
        ],
        "settings": {
          "foreground": colors.syntax.foreground
        }
      },
      {
        "name": "Strings and regexps",
        "scope": [
          "string",
          "string punctuation.section.embedded source",
          "source.regexp",
          "string.regexp",
          "support.type.property-name.json"
        ],
        "settings": {
          "foreground": colors.syntax.string
        }
      },
      {
        "name": "Constants, numbers, supports and language variables",
        "scope": [
          "constant",
          "entity.name.constant",
          "variable.other.constant",
          "variable.other.enummember",
          "variable.language",
          "support",
          "support.constant",
          "support.variable",
          "meta.property-name",
          "string variable"
        ],
        "settings": {
          "foreground": colors.syntax.constant
        }
      },
      {
        "name": "Escapes and placeholders",
        "scope": ["constant.other.placeholder", "constant.character.escape"],
        "settings": {
          "foreground": colors.syntax.keyword
        }
      },
      {
        "name": "Functions and decorators",
        "scope": [
          "entity.name.function",
          "support.function",
          "meta.function.decorator",
          "entity.name.function.decorator",
          "punctuation.definition.decorator"
        ],
        "settings": {
          "foreground": colors.syntax.function
        }
      },
      {
        "name": "Types, classes and tags",
        "scope": [
          "entity.name",
          "entity.name.type",
          "entity.name.tag",
          "support.class.component",
          "meta.definition.variable",
          "punctuation.definition.list.begin.markdown"
        ],
        "settings": {
          "foreground": colors.syntax.type
        }
      },
      {
        "name": "Variables stay plain",
        "scope": ["variable", "variable.other", "variable.parameter.function"],
        "settings": {
          "foreground": colors.syntax.foreground
        }
      },
      {
        "name": "self and cls",
        "scope": ["variable.language.special"],
        "settings": {
          "fontStyle": "italic"
        }
      },
      {
        "name": "Invalid",
        "scope": [
          "invalid.broken",
          "invalid.deprecated",
          "invalid.illegal",
          "invalid.unimplemented",
          "message.error"
        ],
        "settings": {
          "foreground": colors.syntax.invalid,
          "fontStyle": "italic"
        }
      },
      {
        "name": "Markup heading",
        "scope": ["markup.heading", "markup.heading entity.name"],
        "settings": {
          "foreground": colors.syntax.constant,
          "fontStyle": "bold"
        }
      },
      {
        "name": "Markup quote",
        "scope": ["markup.quote"],
        "settings": {
          "foreground": colors.syntax.quote
        }
      },
      {
        "name": "Markup italic",
        "scope": ["markup.italic"],
        "settings": {
          "fontStyle": "italic"
        }
      },
      {
        "name": "Markup bold",
        "scope": ["markup.bold"],
        "settings": {
          "fontStyle": "bold"
        }
      },
      {
        "name": "Markup underline",
        "scope": ["markup.underline"],
        "settings": {
          "fontStyle": "underline"
        }
      },
      {
        "name": "Markup strikethrough",
        "scope": ["markup.strikethrough"],
        "settings": {
          "fontStyle": "strikethrough"
        }
      },
      {
        "name": "Markup inline raw",
        "scope": ["markup.inline.raw"],
        "settings": {
          "foreground": colors.syntax.constant
        }
      },
      {
        "name": "Markup inserted",
        "scope": [
          "markup.inserted",
          "meta.diff.header.to-file",
          "punctuation.definition.inserted"
        ],
        "settings": {
          "foreground": colors.syntax.string
        }
      },
      {
        "name": "Markup deleted",
        "scope": [
          "markup.deleted",
          "meta.diff.header.from-file",
          "punctuation.definition.deleted"
        ],
        "settings": {
          "foreground": colors.syntax.keyword
        }
      },
      {
        "name": "Markup changed",
        "scope": ["markup.changed", "punctuation.definition.changed"],
        "settings": {
          "foreground": colors.syntax.function
        }
      },
      {
        "name": "Diff ranges and separators",
        "scope": ["meta.diff.range", "meta.separator"],
        "settings": {
          "foreground": colors.syntax.function,
          "fontStyle": "bold"
        }
      },
      {
        "name": "Diff header",
        "scope": ["meta.diff.header", "meta.output"],
        "settings": {
          "foreground": colors.syntax.constant
        }
      },
      {
        "name": "Links",
        "scope": ["constant.other.reference.link", "string.other.link"],
        "settings": {
          "foreground": colors.syntax.constant,
          "fontStyle": "underline"
        }
      },
      {
        "name": "Brackets and punctuation",
        "scope": [
          "brackethighlighter.tag",
          "brackethighlighter.curly",
          "brackethighlighter.round",
          "brackethighlighter.square",
          "brackethighlighter.angle",
          "brackethighlighter.quote"
        ],
        "settings": {
          "foreground": colors.syntax.punctuation
        }
      }
    ]
  }
}
