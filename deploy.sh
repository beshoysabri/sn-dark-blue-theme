#!/usr/bin/env bash
#
# Publish sn-dark-blue-theme v2.2.0 to GitHub Pages.
#
# Run from inside your local clone, after copying the new files over.
# One-time setup first: Settings > Pages > Source > "GitHub Actions".
#
set -euo pipefail

REPO_SLUG="beshoysabri/sn-dark-blue-theme"
BRANCH="master"       # this repo's default branch is master, not main
VERSION="2.2.0"
PAGES="https://beshoysabri.github.io/sn-dark-blue-theme"

say() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }

say "Pre-flight — the same checks CI will run"
EXT=$(python3 -c "import json;print(json.load(open('ext.json'))['version'])")
PKG=$(python3 -c "import json;print(json.load(open('package.json'))['version'])")
[ "$EXT" = "$PKG" ] || { echo "version drift: ext.json=$EXT package.json=$PKG"; exit 1; }
[ "$EXT" = "$VERSION" ] || { echo "expected v$VERSION, manifests say v$EXT"; exit 1; }
test -f dist/fonts/InterVariable.woff2
test -f dist/fonts/InterVariable-Italic.woff2
grep -q "url('fonts/InterVariable.woff2')" dist/dist.css
grep -q -- "--sn-stylekit-info-color: #086DD6;" dist/dist.css
test -f .nojekyll
echo "    v$EXT, fonts present, relative srcs, accent intact"

say "Committing"
git add -A
git commit -m "feat(typography): set Super note text in Inter, publish via GitHub Pages

Bundles Inter v4.1 variable (roman + italic, OFL 1.1) and scopes it to the
Lexical/Super editor only. The colour block is byte-identical to v2.1.0 and
code blocks keep their monospace face.

Adds a Pages workflow with pre-publish verification, a landing page, and
repoints ext.json at the Pages origin. Bumps to v${VERSION}."

say "Pushing to ${BRANCH} — this triggers the Pages deploy"
git push origin "${BRANCH}"

say "Tagging"
git tag -a "v${VERSION}" -m "v${VERSION} — Inter for Super"
git push origin "v${VERSION}"

say "Waiting for Pages to publish (usually under a minute)"
for i in $(seq 1 30); do
  if curl -fsS "${PAGES}/ext.json" 2>/dev/null | grep -q "\"version\": \"${VERSION}\""; then
    echo "    live after ~$((i*10))s"
    break
  fi
  [ "$i" -eq 30 ] && { echo "    still stale — check the Actions tab"; exit 1; }
  sleep 10
done

say "Verifying what Pages actually serves"
for path in ext.json dist/dist.css dist/fonts/InterVariable.woff2 dist/fonts/InterVariable-Italic.woff2; do
  read -r code ctype < <(curl -fsS -o /dev/null -w '%{http_code} %{content_type}\n' "${PAGES}/${path}")
  printf '    %-40s %s  %s\n' "$path" "$code" "$ctype"
done

say "Checking CORS on the font (a webfont needs this cross-origin)"
curl -fsSI -H 'Origin: https://app.standardnotes.com' \
  "${PAGES}/dist/fonts/InterVariable.woff2" \
  | grep -i 'access-control-allow-origin' \
  || echo "    WARNING: no ACAO header — confirm the repo is public"

say "Purging the old jsDelivr copies so the legacy URL isn't stale"
for path in ext.json dist/dist.css; do
  curl -fsS "https://purge.jsdelivr.net/gh/${REPO_SLUG}@${BRANCH}/${path}" >/dev/null || true
done

cat <<EOF

Done. ${PAGES}

In Standard Notes, remove the existing Dark Blue theme and reinstall from:
  ${PAGES}/ext.json

The reinstall is one-time — the old install polls the jsDelivr ext.json, so it
won't follow the move to Pages on its own.
EOF
