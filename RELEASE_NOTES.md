fix(daily): restore the "day has an entry" marker, correct two comments

v2.4.0 repainted the Daily calendar's has-an-entry chip with
--sn-stylekit-info-backdrop-color, which is 6% alpha and all but vanishes
against this theme's background. Standard Notes' own colour there is a
clearly visible pale pill, so the affordance that tells you which days
already hold a note was effectively erased. It now keeps the faint wash and
gains a thin accent ring.

The ring is a box-shadow rather than a border: the element ships no
border-width, so the border-color v2.4.0 set on it never rendered.

Two comments in section 4 also named the wrong elements — .bg-danger is
today and .bg-danger-light is a day with an entry, not "the selected day"
and "today when not selected". Corrected; the CSS itself was targeting the
right elements throughout.

deploy.sh: testing that RELEASE_NOTES.md merely exists was not enough. Now
that the file is tracked it always exists, carrying the previous release's
prose — the same trap that made v2.3.0 ship with a message describing
v2.2.0, one release later and with a guard giving false confidence. The
check now requires the notes to name the version being published.

Released as 2.4.1.
