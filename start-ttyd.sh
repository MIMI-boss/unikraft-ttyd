#!/bin/bash
# Start ttyd (writable, with basic auth) on Unikraft Cloud.
# TTYD_CREDENTIAL must be set as an instance env var, format "user:password".
# Never bake the credential into the image.
set -e

if [ -z "$TTYD_CREDENTIAL" ]; then
  echo "TTYD_CREDENTIAL is not set, refusing to start a writable ttyd" >&2
  exit 1
fi

# /data is the persistent volume (512 MiB). If the volume is attached this
# succeeds; on a read-only rootfs without a volume it is a harmless no-op.
mkdir -p /data/bin /data/work 2>/dev/null || true
export PATH="/data/bin:$PATH"

echo "ttyd 7681 starting, writable, basic auth enabled, cwd=/data"
exec /usr/local/bin/ttyd -p 7681 -W -c "$TTYD_CREDENTIAL" -w /data bash
