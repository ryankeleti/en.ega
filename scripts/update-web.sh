#!/usr/bin/env sh

set -x

BASE=$HOME/ega
EGA_DIR="$BASE"
PIPLOC=$(python -c "import site; print(site.USER_BASE)")/bin
FNAME=ega

cd "$BASE" || return

#
# update.
#

#git fetch
#if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
#  git pull
  rm -rf tags "$FNAME"
  python3 "$EGA_DIR"/scripts/make_web.py "$EGA_DIR"

  # 1) update tags file with new tags.
  python3 "$EGA_DIR"/scripts/tagger.py "$FNAME".tex > tags

  # 2) convert to HTML: output goes to $FNAME/
  "$PIPLOC"/plastex --renderer=Gerby ./"$FNAME".tex

  # 3) import tex
  rm -rf "$BASE"/gerby-website/gerby/tex
  git clone https://github.com/ryankeleti/ega "$BASE"/gerby-website/gerby/tex

  # 4) import plasTeX output into database.
  cd "$BASE"/gerby-website/gerby/tools/ || return
  python3 update.py
#fi

