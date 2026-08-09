# Dark Blue Theme for Standard Notes

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Standard Notes](https://img.shields.io/badge/Standard%20Notes-Theme-6366f1.svg)](https://standardnotes.com)

A clean, dark theme for [Standard Notes](https://standardnotes.com) that replaces the default purple accent with a sharp blue, and sets Super notes in [Inter](https://rsms.me/inter/).

Built on the **exact same color foundation** as the native Dark theme — same deep blacks, same contrast ratios, same UI feel. Every purple accent (`#a464c2`) is swapped to blue (`#086DD6`), and nothing else about the palette moves.

## Installation

1. Open Standard Notes
2. Go to **Preferences** > **General** > **Advanced Settings** > **Install Custom Plugin**
3. Paste the following URL:

```
https://beshoysabri.github.io/sn-dark-blue-theme/ext.json
```

4. Click **Install**
5. Select **Dark Blue** from the Appearance menu

There's a preview and a copy button at **[beshoysabri.github.io/sn-dark-blue-theme](https://beshoysabri.github.io/sn-dark-blue-theme)**.

Colors work on Desktop, Web, and Mobile. The Inter typography is Desktop and Web only — Standard Notes doesn't support custom fonts on mobile.

<details>
<summary>Alternative: jsDelivr</summary>

The theme is also reachable over jsDelivr, which is where it lived before v2.2.0:

```
https://cdn.jsdelivr.net/gh/beshoysabri/sn-dark-blue-theme@master/ext.json
```

Both origins serve the same files. GitHub Pages is the default because branch-pinned jsDelivr URLs are cached for roughly 12 hours, so a push doesn't show up until the cache expires or you purge it. Pages republishes on every push to `master`.

</details>

## Hosting

Pushing to `master` triggers `.github/workflows/pages.yml`, which verifies the theme before publishing — that `ext.json` and `package.json` agree on a version, that both woff2 files exist, that the `@font-face` sources are still relative, that the accent color is intact, and that braces balance in `dist.css`. A failed check blocks the deploy rather than shipping a broken stylesheet.

Enable it once under **Settings → Pages → Source → GitHub Actions**.

## Color Palette

| Role | Hex | Preview |
|------|-----|---------|
| Background | `#0f1011` | ![0f1011](https://img.shields.io/badge/-0f1011-0f1011?style=flat-square) |
| Surface | `#1c1d1e` | ![1c1d1e](https://img.shields.io/badge/-1c1d1e-1c1d1e?style=flat-square) |
| Border | `#181a1b` | ![181a1b](https://img.shields.io/badge/-181a1b-181a1b?style=flat-square) |
| Foreground | `#eeeeee` | ![eeeeee](https://img.shields.io/badge/-eeeeee-eeeeee?style=flat-square) |
| Accent (Blue) | `#086DD6` | ![086DD6](https://img.shields.io/badge/-086DD6-086DD6?style=flat-square) |
| Success | `#2b9612` | ![2b9612](https://img.shields.io/badge/-2b9612-2b9612?style=flat-square) |
| Warning | `#cc8800` | ![cc8800](https://img.shields.io/badge/-cc8800-cc8800?style=flat-square) |
| Danger | `#f80324` | ![f80324](https://img.shields.io/badge/-f80324-f80324?style=flat-square) |

## Typography

Since v2.2.0, the text inside **Super** notes is set in Inter v4.1 — the variable font, roman and italic, bundled in `dist/fonts/` under the SIL Open Font License. It ships with the theme rather than loading from Google Fonts, so it resolves over jsDelivr and keeps working offline.

Scoping is deliberate. Super is the only [Lexical](https://lexical.dev) surface in the app, so `[data-lexical-editor='true']` is the hook, with `#blocks-editor`, `#super-editor` and `.ContentEditable__root` alongside it in case the app renames one. Plaintext, Markdown and code editors stay on the system font. Inside Super, code blocks and inline code keep their monospace face:

| Rule | Selector shape | Specificity |
|---|---|---|
| Body | `:is(<roots>) *` | (1,0,0) |
| Code | `:is(<roots>) :is(pre, code, kbd, samp, [class*='code' i])` | (1,1,0) |

The code rule outranks the body rule, so syntax-highlight tokens nested inside a code block inherit monospace correctly.

Three variables at the top of `dist/dist.css` control it:

| Variable | Purpose |
|---|---|
| `--sn-inter-font` | The family stack. Inter has no Arabic or CJK glyphs, so those scripts fall through to the next family rather than rendering as boxes. |
| `--sn-inter-mono` | Code face. Defaults to whatever Standard Notes already uses. |
| `--sn-inter-features` | OpenType features. `cv05` gives lowercase `l` a tail so it stops looking like a capital `I`. Set to `normal` to disable. |

Section 4 of the stylesheet has commented-out extras: matching the note title, tighter heading tracking, roomier leading, tabular figures in tables, and a one-liner that applies Inter across the whole app instead of just Super.

**Platform note:** custom fonts work on Desktop and Web. Standard Notes does not support custom fonts on mobile, so the mobile app renders the colors only and falls back to the system font.

## What Changed vs Native Dark

The accent color, and the Super editor font. Every background, border, shadow, and text color is identical to the built-in Dark theme. The purple-to-blue swap applies to:

- Selected items and navigation highlights
- Links, buttons, and focus rings
- Text selection background
- Scrollbar thumb
- Note preview progress bar
- Component highlight color
- Titlebar hover state

## Customization

Want a different blue? Replace `#086DD6` in `dist/dist.css` with your preferred shade:

| Name | Hex |
|------|-----|
| **Standard Notes Blue** | `#086DD6` (default) |
| Material Blue | `#2196F3` |
| Tailwind Blue 600 | `#2563EB` |
| VS Code Blue | `#007ACC` |
| Notion Blue | `#2383E2` |

## License

Theme: MIT — see `LICENSE`.
Inter: SIL Open Font License 1.1 — see `LICENSE-3RD-PARTY`.
