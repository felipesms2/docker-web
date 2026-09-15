#!/usr/bin/env bash
# Mantido para compatibilidade com a URL de instalacao antiga.
exec bash <(curl -fsSL https://raw.githubusercontent.com/felipesms2/docker-web/main/startup.sh) "$@"
