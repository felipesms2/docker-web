# docker-web

Inicializador Docker para projetos Laravel, sites estaticos e projetos Node
cujo resultado de producao e uma pasta estatica `dist/`.

## Uso

No diretorio do projeto, execute:

```bash
curl -fsSL https://raw.githubusercontent.com/felipesms2/docker-web/main/startup.sh | bash
```

O assistente pergunta o tipo de projeto. Para automacao, informe a opcao sem
prompt:

```bash
curl -fsSL https://raw.githubusercontent.com/felipesms2/docker-web/main/startup.sh | PROJECT_TYPE=node-static bash
```

### Exemplo: migrar o digi-com (Vite) para Apache estatico

Depois de gerar `dist/` com `npm run build`, execute este bloco na raiz do
projeto. Ele baixa o `docker-web`, seleciona o perfil Node com build estatico e substitui o
Compose legado. A configuracao anterior e salva automaticamente em uma pasta
`.docker-web-backup-AAAAMMDDHHMMSS`.

```bash
npm run build
curl -fsSL https://raw.githubusercontent.com/felipesms2/docker-web/main/startup.sh | PROJECT_TYPE=static bash
docker compose up -d
```

O site ficara disponivel em `http://localhost:8080`. Nao ha processo Node em
execucao no container: o Apache serve os arquivos ja gerados em `dist/`.

Opcoes disponiveis:

- `laravel`: Apache com `public/`, Composer, Artisan e os servicos MariaDB e phpMyAdmin.
- `static`: somente Apache, servindo os arquivos na raiz do projeto. Nao executa Composer, Artisan, banco ou Node.
- `node-static`: somente Apache, servindo `dist/`. Execute `npm run build` antes de iniciar o container; Node nao fica escutando porta alguma.

Depois da instalacao, use `docker compose up` para sites estaticos e Node.
Para Laravel, use `docker compose --profile laravel up`.

A imagem padrao e `felipesms/liga:1.2`.
