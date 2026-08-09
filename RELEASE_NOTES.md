feat: recolour the Daily view to the accent, correct the font documentation

The Daily notebook borrows Standard Notes' `danger` token for today's date,
the selected day, the entry tiles and both create-note buttons, so they
rendered #f80324 against an otherwise blue theme. A new section 4 repaints
only those elements, and only by referencing accent variables the palette
already defines. Genuinely destructive UI keeps its red. Because the rules
reference --sn-stylekit-* rather than declaring any, all 90 colour
declarations remain byte-identical to v2.1.0.

Fixes a bug introduced in v2.3.0: the italic face declared
local('InterVariable Italic'), which matches nothing. The font's real records
are PostScript 'InterVariableItalic' and full name 'Inter Variable Italic',
so italics were being synthesised by slanting the roman on every client that
uses a local copy. Both faces now list their PostScript and full names, and
'Inter Variable' — the family an installed InterVariable.ttf registers under —
joins the stack alongside 'Inter'.

Docs: mobile does support custom fonts after all. Downloading a webfont is
what mobile refuses; a font installed on the device resolves through the
family stack exactly as it does on desktop. Confirmed on both iOS and
Android. Every previous release claimed the opposite.

CI: the colour digest covered 51 of 93 custom properties, leaving 39 real
colours — navigation, items column, editor, titlebar, text selection,
popover — completely unguarded. It now digests all 90. Also added an
assertion that some rule actually applies --sn-inter-font: a font that is
declared but never applied is exactly how v2.2.0 passed CI while rendering
nothing in any client.

deploy.sh: the commit message now comes from this file rather than being
frozen in the script, which is how v2.3.0 shipped carrying a message
describing v2.2.0. It also derives VERSION from ext.json, refuses to run
from the wrong branch, survives a re-run after a partial failure, exits
non-zero on a non-200 asset instead of printing "Done.", and verifies the
jsDelivr purge actually landed.
