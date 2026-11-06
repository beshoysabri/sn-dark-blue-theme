fix: install from the desktop app, under Plugins; deploy.sh on Windows

The README and landing page sent people to Preferences → General →
Advanced Settings → Install Custom Plugin. Current Standard Notes
(v3.203.0) has it under Preferences → Plugins, at the bottom of the
page. Both now give that path, and say where older versions kept it.

Both also say to install from the desktop app. The web app can't install
any self-hosted theme from a link: its CSP connect-src allows only
Standard Notes' own servers, raw.githubusercontent.com and listed.to, so
the github.io link fails with "Error downloading package details". A
raw.githubusercontent.com link fails too: Standard Notes sends the request
with credentials, and GitHub answers Access-Control-Allow-Origin: *.
Installed themes sync with the account, and the web app then loads the
stylesheet and fonts from Pages without complaint (style-src *,
font-src *) — verified against app.standardnotes.com v3.203.0.

deploy.sh: native Windows curl ends its -w write-out with \r\n, and read
keeps the \r, so 'font/woff2\r' failed the content-type check. On Windows
a healthy deploy reported broken assets and exited before the CORS check
and the jsDelivr purge. The \r is now stripped.

No colour changes; the CI digest is untouched.

Released as 2.4.2.
