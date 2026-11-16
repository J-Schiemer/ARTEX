#!/usr/bin/env bash
# Smoke-test BBOT's screenshot integration entirely inside the image.
set -euo pipefail

image=${1:-artex:local}
docker run --rm --network none -i --entrypoint sh "$image" <<'CONTAINER'
set -eu
python -m http.server 18999 --bind 127.0.0.1 --directory /tmp >/tmp/http.log 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true' EXIT
ready=0
for attempt in 1 2 3 4 5; do
    if curl -fsS http://127.0.0.1:18999/ >/dev/null; then
        ready=1
        break
    fi
    sleep 1
done
test "$ready" = 1
bbot -t http://127.0.0.1:18999 -m gowitness --no-deps -y --no-color \
    -o /tmp/bbot-smoke -n local-smoke
test -n "$(find /tmp/bbot-smoke/local-smoke/gowitness/screenshots -type f \( -name '*.jpeg' -o -name '*.png' \) -size +0c -print -quit)"
grep -q '"type": "WEBSCREENSHOT"' /tmp/bbot-smoke/local-smoke/output.json
CONTAINER
