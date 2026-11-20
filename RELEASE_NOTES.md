fix: keep the theme's fonts out of editor plugins

Standard Notes loads the active theme into every editor plugin's frame
as well as into its own page, so plugins can use the theme's colours.
The rule that sets Inter targeted html, body, body * with !important, so
it reached into those frames too and replaced each plugin's own type: a
commonplace-book plugin's serif came out in Inter.

Section 3 and the code rule now apply only to the page that holds #app-
group-root, Standard Notes' app root (a constant in its shared web code,
so the same on web, desktop and mobile), which no plugin frame has.
Menus and dialogs are portals beside it, so they stay covered. :where()
keeps the app-wide rule at zero specificity; the code rule now wins on
specificity rather than source order.

The "confine Inter to the editor" opt-in used font-family: revert, which
falls through to the browser's default font (Arial in the check) rather
than Standard Notes' own; it now sets var(--sn-stylekit-sans-serif-font)
(Ubuntu in the check, as with no theme), and keeps code monospace inside
the editor. The heading-tracking and arrows-off opt-ins are scoped like
section 3.

CI: fails if the app-wide rule loses its scope or any rule targets bare
body *. Colours are unchanged; the digest still matches.

Checked in app.standardnotes.com: the sidebar and an open menu are still
drawn in Inter, the Monospace option and the arrows opt-out still work;
and in a plugin frame the plugin's own fonts are back while its colours
follow the theme.

Released as 2.4.4.
