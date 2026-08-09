#!/usr/bin/env bash
#
# Publish sn-dark-blue-theme to GitHub Pages.
#
# Run from inside your local clone, after copying the new files over.
# One-time setup first: Settings > Pages > Source > "GitHub Actions".
#
# The commit message is read from RELEASE_NOTES.md (override with $MSG_FILE).
# It used to be baked into this script, which is how v2.3.0 shipped carrying a
# message describing v2.2.0's changes.
#
set -euo pipefail

REPO_SLUG="beshoysabri/sn-dark-blue-theme"
BRANCH="master"       # this repo's default branch is master, not main
PAGES="https://beshoysabri.github.io/sn-dark-blue-theme"
MSG_FILE="${MSG_FILE:-RELEASE_NOTES.md}"

# Derived from the manifest — one less place to forget to bump.
VERSION=$(python3 -c "import json;print(json.load(open('ext.json'))['version'])")

# Refuse to publish from the wrong branch.
CURRENT=$(git rev-parse --abbrev-ref HEAD)
[ "$CURRENT" = "$BRANCH" ] || { echo "on '$CURRENT', expected '$BRANCH' — refusing"; exit 1; }

say() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }

say "Pre-flight — the same checks CI will run"
EXT=$(python3 -c "import json;print(json.load(open('ext.json'))['version'])")
PKG=$(python3 -c "import json;print(json.load(open('package.json'))['version'])")
[ "$EXT" = "$PKG" ] || { echo "version drift: ext.json=$EXT package.json=$PKG"; exit 1; }
[ "$EXT" = "$VERSION" ] || { echo "expected v$VERSION, manifests say v$EXT"; exit 1; }
test -f dist/fonts/InterVariable.woff2
test -f dist/fonts/InterVariable-Italic.woff2
PAGES_FONTS="https://beshoysabri.github.io/sn-dark-blue-theme/dist/fonts"
grep -q "url('${PAGES_FONTS}/InterVariable.woff2')" dist/dist.css
grep -q "url('${PAGES_FONTS}/InterVariable-Italic.woff2')" dist/dist.css
grep -q -- "--sn-stylekit-info-color: #086DD6;" dist/dist.css
test -f .nojekyll
echo "    v$EXT, fonts present, absolute srcs, accent intact"

say "Committing"
test -f "$MSG_FILE" || { echo "no $MSG_FILE — write this release's notes first"; exit 1; }
git add -A
if git diff --cached --quiet; then
  echo "    nothing staged — reusing $(git rev-parse --short HEAD)"
else
  git commit -F "$MSG_FILE"
fi

say "Pushing to ${BRANCH} — this triggers the Pages deploy"
git push origin "${BRANCH}"

say "Tagging"
if git rev-parse -q --verify "refs/tags/v${VERSION}" >/dev/null; then
  echo "    v${VERSION} already tagged locally"
else
  git tag -a "v${VERSION}" -F "$MSG_FILE"
fi
git push origin "v${VERSION}" 2>&1 | tail -1

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
BAD=0
for path in ext.json dist/dist.css dist/fonts/InterVariable.woff2 dist/fonts/InterVariable-Italic.woff2; do
  read -r code ctype < <(curl -sS -o /dev/null -w '%{http_code} %{content_type}\n' "${PAGES}/${path}")
  printf '    %-40s %s  %s\n' "$path" "$code" "$ctype"
  [ "$code" = "200" ] || BAD=1
  case "$path" in
    *.woff2) [ "${ctype%%;*}" = "font/woff2" ] || BAD=1 ;;
  esac
done
# Reporting a 404 and then printing "Done." is how a broken deploy looks healthy.
[ "$BAD" -eq 0 ] || { echo "    one or more assets are wrong — see above"; exit 1; }

say "Checking CORS on the font (a webfont needs this cross-origin)"
curl -fsSI -H 'Origin: https://app.standardnotes.com' \
  "${PAGES}/dist/fonts/InterVariable.woff2" \
  | grep -i 'access-control-allow-origin' \
  || echo "    WARNING: no ACAO header — confirm the repo is public"

say "Purging the old jsDelivr copies so the legacy URL isn't stale"
# Fire-and-forget left jsDelivr serving a stale ext.json after v2.3.0, so
# confirm the purge actually landed rather than assuming it did.
for path in ext.json dist/dist.css; do
  curl -fsS "https://purge.jsdelivr.net/gh/${REPO_SLUG}@${BRANCH}/${path}" >/dev/null || true
done
sleep 5
JSD=$(curl -fsS "https://cdn.jsdelivr.net/gh/${REPO_SLUG}@${BRANCH}/ext.json" \
      | python3 -c "import json,sys;print(json.load(sys.stdin)['version'])" 2>/dev/null || echo '?')
if [ "$JSD" = "$VERSION" ]; then
  echo "    jsDelivr now serving v${JSD}"
else
  echo "    NOTE: jsDelivr still serving v${JSD} — its cache can take up to 12h."
  echo "          Harmless: ext.json points installs at Pages either way."
fi

cat <<EOF

Done. ${PAGES}

In Standard Notes, remove the existing Dark Blue theme and reinstall from:
  ${PAGES}/ext.json

The reinstall is one-time — the old install polls the jsDelivr ext.json, so it
won't follow the move to Pages on its own.
EOF
