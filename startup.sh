#!/usr/bin/env bash
# Instala os arquivos do docker-web no projeto atual.
set -eu

repository="https://github.com/felipesms2/docker-web.git"
target_dir="${1:-.}"

if [ ! -d "$target_dir" ]; then
  echo "Diretorio inexistente: $target_dir" >&2
  exit 1
fi

if [ -z "${PROJECT_TYPE:-}" ] && [ -t 0 ]; then
  echo "Tipo de projeto:"
  select selected_type in "Laravel (PHP + MariaDB)" "Site estatico (somente Apache)" "Node com build estatico (Apache serve dist/)"; do
    case "$REPLY" in
      1) PROJECT_TYPE=laravel; break ;;
      2) PROJECT_TYPE=static; break ;;
      3) PROJECT_TYPE=node-static; break ;;
      *) echo "Escolha 1, 2 ou 3." ;;
    esac
  done
fi

PROJECT_TYPE="${PROJECT_TYPE:-laravel}"
case "$PROJECT_TYPE" in laravel|static|node-static) ;; *)
  echo "PROJECT_TYPE deve ser laravel, static ou node-static." >&2
  exit 1
esac

template_dir="$(mktemp -d)"
cleanup() { rm -rf "$template_dir"; }
trap cleanup EXIT

git clone --depth 1 "$repository" "$template_dir/docker-web"
source_dir="$template_dir/docker-web"

backup_dir="$target_dir/.docker-web-backup-$(date +%Y%m%d%H%M%S)"
for file in docker-compose.yml docker-compose.yaml entrypoint.sh .docker-web.env; do
  if [ -e "$target_dir/$file" ]; then
    mkdir -p "$backup_dir"
    mv "$target_dir/$file" "$backup_dir/$file"
  fi
done

mkdir -p "$target_dir/resources/config"
cp "$source_dir/docker-compose.yaml" "$target_dir/docker-compose.yaml"
cp "$source_dir/entrypoint.sh" "$target_dir/entrypoint.sh"
cp "$source_dir/templates/$PROJECT_TYPE/000-default.conf" "$target_dir/resources/config/000-default.conf"
cp "$source_dir/ports.conf" "$target_dir/resources/config/ports.conf"
cp "$source_dir/envvars" "$target_dir/resources/config/envvars"

if [ "$PROJECT_TYPE" = "node-static" ]; then
  cp "$source_dir/templates/node-static/build-static.sh" "$target_dir/build-static.sh"
  chmod +x "$target_dir/build-static.sh"
fi

printf 'PROJECT_TYPE=%s\nINSTALL_DEPENDENCIES=true\n' "$PROJECT_TYPE" > "$target_dir/.docker-web.env"
chmod +x "$target_dir/entrypoint.sh"

echo "docker-web configurado para: $PROJECT_TYPE"
if [ -d "$backup_dir" ]; then
  echo "Arquivos Docker anteriores foram salvos em: $backup_dir"
fi
echo "Inicie com: docker compose --profile laravel up (Laravel) ou docker compose up (demais tipos)."
