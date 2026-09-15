#!/usr/bin/env bash
# Compila um projeto Node sem instalar Node no host.
set -euo pipefail

project_dir="$(pwd)"
host_uid="$(id -u)"
host_gid="$(id -g)"

run_npm() {
  docker run --rm -it \
    -v "$project_dir:/app" \
    --network host \
    -w /app \
    node:24 \
    npm "$@"
}

run_npm ci
run_npm run build

# O Node no container roda como root; entregue os arquivos gerados ao usuario
# atual do host para que eles continuem editaveis fora do Docker.
docker run --rm -it \
  -e HOST_UID="$host_uid" \
  -e HOST_GID="$host_gid" \
  -v "$project_dir:/app" \
  -w /app \
  node:24 \
  sh -c 'find /app -xdev -user root -exec chown "$HOST_UID:$HOST_GID" {} +'
