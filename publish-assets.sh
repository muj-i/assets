#!/bin/bash
# Cross-repo asset consolidation. Run from anywhere; stops on first error.
#
# Ordering is deliberate: the new repo must exist and all refs must already
# point at it before anything is deleted from the old repos.
set -euo pipefail

STAGED="/Users/muj/codeSpace/proj/assets"
PROFILE="/Users/muj/codeSpace/proj/muj-i"
MOCKS="/Users/muj/codeSpace/proj/mocks"

echo "==> 1/4  create public repo muj-i/assets"
gh repo create muj-i/assets --public \
  --description "Static assets for muj-i.github.io and the muj-i profile README"

echo "==> 2/4  push the 65 consolidated files"
cd "$STAGED"
git init -q -b main
git add -A
git commit -qm "feat: consolidate assets from muj-i and mocks

Brings every image into one public repo with a predictable layout and
lowercase, hyphenated filenames so URLs stay clean."
git remote add origin "https://github.com/muj-i/assets.git"
git push -qu origin main
echo "    pushed $(git ls-files | wc -l | tr -d ' ') files"

echo "==> 3/4  commit the rewritten profile README (refs already updated)"
cd "$PROFILE"
git add README.md
git commit -qm "docs: point icon refs at the consolidated assets repo"
git push -q

echo "    waiting for jsDelivr to warm up"
sleep 10
for probe in icons/mysql.svg profile/me-new.png certificates/c7841-mujahedul-islam.png; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://cdn.jsdelivr.net/gh/muj-i/assets@main/$probe")
  echo "    $probe -> $code"
  [ "$code" = "200" ] || { echo "ABORT: asset not serving, nothing deleted."; exit 1; }
done

echo "==> 4/4  remove the moved assets from the old repos"
cd "$PROFILE"
git rm -rq icons imgs gifs
git rm -q -- *.pdf
git commit -qm "chore: drop assets now living in muj-i/assets"
git push -q

cd "$MOCKS"
git rm -rq certificates company_mocs
git rm -q -- *.png
git commit -qm "chore: drop assets now living in muj-i/assets"
git push -q

echo
echo "Done. Next: open /you-know-who, paste an asset token, click 'Relink assets'."
