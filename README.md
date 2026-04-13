# Dark Blue — Standard Notes Theme

A clean, dark theme for [Standard Notes](https://standardnotes.com) that replaces the default purple accent with a sharp blue.

Built on the **exact same color foundation** as the native Dark theme — same deep blacks, same contrast ratios, same UI feel. The only difference: every purple accent (`#a464c2`) is swapped to blue (`#086DD6`).

## Installation

1. Open Standard Notes
2. Go to **Preferences** > **General** > **Advanced Settings** > **Install Custom Plugin**
3. Paste the following URL:

```
https://cdn.jsdelivr.net/gh/beshoysabri/sn-dark-blue-theme@master/ext.json
```

4. Click **Install**
5. Select **Dark Blue** from the Appearance menu

Works on Desktop, Web, and Mobile.

## Color Palette

| Role | Hex | Preview |
|------|-----|---------|
| Background | `#0f1011` | ![#0f1011](https://via.placeholder.com/16/0f1011/0f1011.png) |
| Surface | `#1c1d1e` | ![#1c1d1e](https://via.placeholder.com/16/1c1d1e/1c1d1e.png) |
| Border | `#181a1b` | ![#181a1b](https://via.placeholder.com/16/181a1b/181a1b.png) |
| Foreground | `#eeeeee` | ![#eeeeee](https://via.placeholder.com/16/eeeeee/eeeeee.png) |
| Accent (Blue) | `#086DD6` | ![#086DD6](https://via.placeholder.com/16/086DD6/086DD6.png) |
| Success | `#2b9612` | ![#2b9612](https://via.placeholder.com/16/2b9612/2b9612.png) |
| Warning | `#cc8800` | ![#cc8800](https://via.placeholder.com/16/cc8800/cc8800.png) |
| Danger | `#f80324` | ![#f80324](https://via.placeholder.com/16/f80324/f80324.png) |

## What Changed vs Native Dark

Only the accent color. Every background, border, shadow, and text color is identical to the built-in Dark theme. The purple-to-blue swap applies to:

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

MIT
