#!/usr/bin/env bash
# Aplica o template moon-base em outro repositório (da Vetryak ou de cliente).
#
# Uso:
#   ./scripts/adopt.sh <repo-destino> [--force]
#
# Copia: .moon/, .prototools, templates/, .editorconfig, .github/workflows/moon-ci.yml,
#        CLAUDE.md, .gemini/settings.json, .github/copilot-instructions.md
#        e as pastas do layout VSA (apps, slices, libs, infra, tools) com seus READMEs.
# Não sobrescreve arquivos existentes, a menos que --force seja passado.
# Registra a versão aplicada em .moon/moon-base.version.
set -euo pipefail

usage() { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

[[ $# -ge 1 ]] || usage
DEST="$1"; FORCE="${2:-}"
[[ -d "$DEST" ]] || { echo "Destino não existe: $DEST" >&2; exit 1; }
[[ -z "$FORCE" || "$FORCE" == "--force" ]] || usage

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$(cd "$DEST" && pwd)"
[[ "$SRC" != "$DEST" ]] || { echo "Destino não pode ser o próprio moon-base." >&2; exit 1; }

copy() {
  local rel="$1" target="$DEST/$1"
  if [[ -e "$target" && "$FORCE" != "--force" ]]; then
    echo "  manter    $rel (já existe)"
    return
  fi
  mkdir -p "$(dirname "$target")"
  cp "$SRC/$rel" "$target"
  echo "  copiar    $rel"
}

echo "moon-base -> $DEST"

# Arquivos de configuração do moon e ferramentas
while IFS= read -r f; do copy "$f"; done < <(
  cd "$SRC" && find .moon templates -type f ! -path ".moon/cache/*" ! -path ".moon/docker/*" | sort
)
for f in .prototools .editorconfig .github/workflows/moon-ci.yml; do copy "$f"; done

# Ponteiros multi-LLM (o AGENTS.md é específico de cada repositório e não é copiado)
for f in CLAUDE.md .gemini/settings.json .github/copilot-instructions.md; do copy "$f"; done

# Layout VSA (apenas READMEs; nenhuma slice de exemplo)
for d in apps libs infra tools; do copy "$d/README.md"; done
mkdir -p "$DEST/slices" && [[ -e "$DEST/slices/.gitkeep" ]] || touch "$DEST/slices/.gitkeep"

# .gitignore: acrescenta entradas do moon sem duplicar
GI="$DEST/.gitignore"; touch "$GI"
for line in ".moon/cache/" ".moon/docker/"; do
  grep -qxF "$line" "$GI" || { echo "$line" >> "$GI"; echo "  gitignore $line"; }
done

# Versão aplicada
VERSION="$(git -C "$SRC" describe --tags --always 2>/dev/null || echo desconhecida)"
printf 'source: https://github.com/vetryak/moon-base\nversion: %s\napplied: %s\n' \
  "$VERSION" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$DEST/.moon/moon-base.version"
echo "  versão    $VERSION (.moon/moon-base.version)"

cat <<MSG

Pronto. Próximos passos no destino:
  1. Ajuste 'projects' em .moon/workspace.yml se o layout for diferente.
  2. proto use            # instala moon/node fixados no .prototools
  3. moon generate slice  # cria a primeira slice
  4. Escreva o AGENTS.md do repositório (CLAUDE.md, Gemini e Copilot já apontam para ele).
MSG
