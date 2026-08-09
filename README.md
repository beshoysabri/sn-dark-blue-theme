# Dark Blue Theme for Standard Notes

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Standard Notes](https://img.shields.io/badge/Standard%20Notes-Theme-6366f1.svg)](https://standardnotes.com)

A clean, dark theme for [Standard Notes](https://standardnotes.com) that replaces the default purple accent with a sharp blue, and sets the app in [Inter](https://rsms.me/inter/).

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

| Client | Colours | Inter |
|---|---|---|
| Web | yes | yes, downloaded automatically |
| Desktop | yes | only with Inter installed on the machine — see below |
| Mobile | yes | no — Standard Notes doesn't support custom fonts on mobile |

### Desktop needs Inter installed locally

The desktop app sends `Content-Security-Policy: default-src 'self' blob:` with no `font-src`, so it refuses to download **any** webfont — from this repo, from a CDN, or inlined as a `data:` URI. No theme can ship a font file into it. Verified against the app, not assumed.

What does work is a font already on your machine: no download, so CSP has nothing to block. The stack is written so an installed copy is found automatically.

1. Download Inter from [rsms.me/inter](https://rsms.me/inter/)
2. Install `InterVariable.ttf` (inside `Desktop/` in the zip) — Font Book on macOS, right-click → Install on Windows
3. Fully quit Standard Notes and reopen it; the system font list is read at launch

Skip this and the theme still works — you get the colours, and the text stays on the system font.

<details>
<summary>Alternative: jsDelivr</summary>

The theme is also reachable over jsDelivr, which is where it lived before v2.2.0:

```
https://cdn.jsdelivr.net/gh/beshoysabri/sn-dark-blue-theme@master/ext.json
```

Both origins serve the same files. GitHub Pages is the default because branch-pinned jsDelivr URLs are cached for roughly 12 hours, so a push doesn't show up until the cache expires or you purge it. Pages republishes on every push to `master`.

</details>

## Hosting

Pushing to `master` triggers `.github/workflows/pages.yml`, which verifies the theme before publishing — that `ext.json` and `package.json` agree on a version, that both woff2 files exist, that both `@font-face` sources are the absolute Pages URLs, that all 51 `--sn-stylekit-*` colour declarations still hash to the v2.1.0 digest, that the section 4 opt-ins are still commented out, and that braces balance in the comment-stripped `dist.css`. A failed check blocks the deploy rather than shipping a broken stylesheet.

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

Since v2.3.0 the whole app is set in Inter v4.1 — sidebar, note list, menus and note text. The variable font, roman and italic, is bundled in `dist/fonts/` under the SIL Open Font License.

v2.2.0 scoped Inter to Super notes only. That left the rest of the UI on the system font, and — because of the CSP above — never actually loaded on Desktop at all.

Two details make it work where v2.2.0 didn't:

- **The `@font-face` sources are absolute, not relative.** Standard Notes inlines theme CSS instead of linking it, so a relative `url('fonts/…')` resolves against the app's own origin and 404s. v2.2.0 shipped that bug; the fonts never loaded in any client.
- **The family is set on elements, not through a variable.** Standard Notes doesn't read `--sn-stylekit-sans-serif-font` for its own chrome, so setting that variable changes nothing. `html, body, body *` is what actually reaches the UI.

Code keeps a monospace face. That rule is listed after the app-wide one so it wins at equal specificity, and it disables contextual alternates so `->` stays two characters where that matters.

Three variables at the top of `dist/dist.css` control it:

| Variable | Purpose |
|---|---|
| `--sn-inter-font` | The family stack. Inter has no Arabic or CJK glyphs, so those scripts fall through to the next family rather than rendering as boxes. |
| `--sn-inter-mono` | Code face. Defaults to whatever Standard Notes already uses. |
| `--sn-inter-features` | OpenType features. `cv05` gives lowercase `l` a tail so it stops looking like a capital `I`. Set to `normal` to disable. |

Inter's contextual alternates fuse `->` into a single `→` glyph. If the caret feels off by one when you arrow across it, section 4 has a block that turns ligatures back off — along with tighter heading tracking, roomier leading, tabular figures in tables, and a block that confines Inter to the editor again the way v2.2.0 did.

## What Changed vs Native Dark

The accent color, and the font. Every background, border, shadow, and text color is identical to the built-in Dark theme. The purple-to-blue swap applies to:

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
