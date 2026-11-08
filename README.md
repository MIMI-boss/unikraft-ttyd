# unikraft-ttyd

ttyd (terminal over the web) on Unikraft Cloud, built from a small Ubuntu 24.04
image with network and system tools baked in.

## What is in the image

- Ubuntu 24.04, `ttyd` 1.7.7 (SHA256-verified release binary)
- Network tools: `ip`, `ss`, `ping`, `curl`, `wget`, `dig`, `host`, `nslookup`,
  `ifconfig`, `netstat`, `route`
- System tools: `bash`, `tmux`, `vim`, `jq`, `git`, `ssh`, `python3`, `procps`

## Layout

- `Dockerfile` — builds the root filesystem (apt install + ttyd binary)
- `Kraftfile` — Unikraft runtime `base-compat:latest`, target `kraftcloud/x86_64`,
  rootfs as EROFS, starts `tini` + `start-ttyd.sh`
- `start-ttyd.sh` — starts `ttyd -p 7681 -W` with basic auth from the
  `TTYD_CREDENTIAL` environment variable (`user:password`), working directory
  `/data`

## Deploy

The image is built by the Unikraft Cloud remote build service and run in
`fra` as 1 vCPU / 512 MiB RAM with a 512 MiB volume mounted at `/data`.
The root filesystem is read-only; `/data` is the writable space (for example
for a proxy binary and its config). No credential is stored in this repo:
`TTYD_CREDENTIAL` is passed as an instance environment variable at deploy time.
