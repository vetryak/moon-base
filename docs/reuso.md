# Como reutilizar o moon-base

Há dois jeitos. Use a **cópia** por padrão; use **extends** quando quiser que
um repositório receba atualizações das tarefas sem copiar de novo.

## 1. Cópia (recomendado)

```bash
git clone https://github.com/vetryak/moon-base
./moon-base/scripts/adopt.sh ../meu-repo          # não sobrescreve nada existente
./moon-base/scripts/adopt.sh ../meu-repo --force  # atualiza para a versão atual
```

O script copia `.moon/`, `.prototools`, `templates/`, `.editorconfig`, o
workflow `moon-ci.yml`, os ponteiros multi-LLM (`CLAUDE.md`, `.gemini/`,
`.github/copilot-instructions.md`) e os READMEs do layout, e grava a versão aplicada em
`.moon/moon-base.version`.

Funciona também em repositórios de clientes, inclusive fora do GitHub da
Vetryak: o resultado não depende deste repositório.

## 2. extends (atualização centralizada)

O moon aceita `extends` com URL. No repositório consumidor, cada arquivo de
tarefas pode só apontar para uma **tag** do moon-base:

```yaml
# meu-repo/.moon/tasks/python.yml
extends: "https://raw.githubusercontent.com/vetryak/moon-base/v0.1.0/.moon/tasks/python.yml"
```

O `inheritedBy` do arquivo de origem é herdado junto. Sempre aponte para uma
tag (nunca `main`) para que uma mudança aqui não quebre outros repositórios sem
aviso. Requer acesso de rede a `raw.githubusercontent.com` em quem roda o moon.

## Atualizando o template

1. Altere aqui, valide (`moon ci`) e abra PR.
2. Após o merge, crie uma tag semântica (`v0.2.0`).
3. Nos consumidores: `adopt.sh --force` (cópia) ou suba a tag no `extends`.
