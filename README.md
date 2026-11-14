# moon-base

Template [moonrepo](https://moonrepo.dev) (moon v2) da **Vetryak** para
monorepos organizados em **Vertical Slice Architecture (VSA)**. É a base dos
repositórios da org (`vetryak-demos-hub`, `vetryak-docs-hub`) e de projetos com
clientes: mesma estrutura, mesmos nomes de tarefas e o mesmo CI em todo lugar.

## O que vem pronto

- **Workspace moon v2** com descoberta de projetos pelo layout VSA, VCS git/GitHub e cache do pipeline.
- **Tarefas herdadas** por linguagem e por tag: Python (ruff, pytest), Node/TypeScript (scripts do `package.json`), Terraform (fmt, validate) e containers (docker build).
- **Gerador de slices**: `moon generate slice` cria `slices/<dominio>/<feature>` já com `moon.yml`, README e testes.
- **CI base** (`.github/workflows/moon-ci.yml`) rodando `moon ci`, que executa só o que foi afetado.
- **Script de adoção** (`scripts/adopt.sh`) para aplicar o template em qualquer repositório.
- **Instruções multi-LLM**: `AGENTS.md` como fonte única, com `CLAUDE.md`, Gemini e Copilot apontando para ele.

## Estrutura

```
moon-base/
├── .moon/
│   ├── workspace.yml        # projetos, VCS, pipeline, gerador
│   ├── toolchains.yml       # "system" por padrão
│   └── tasks/               # tarefas herdadas
│       ├── all.yml          #   todos os projetos (fileGroups)
│       ├── python.yml       #   language: python
│       ├── node.yml         #   language: javascript | typescript
│       ├── terraform.yml    #   tag: terraform
│       └── container.yml    #   tag: container
├── apps/                    # pontos de entrada implantáveis (compõem slices)
├── slices/                  # fatias verticais: <dominio>/<feature>
│   └── exemplo/saudacao/    #   slice de referência
├── libs/                    # compartilhado (só com 2+ consumidores)
├── infra/                   # infraestrutura compartilhada (Terraform)
├── tools/                   # scripts e utilitários internos
├── templates/slice/         # template do `moon generate slice`
├── scripts/adopt.sh         # aplica o template em outro repositório
├── docs/                    # convenções, reuso, agentes, ADRs
├── .prototools              # moon 2.6.5, node 22.11.0
├── AGENTS.md                # instruções para agentes de IA (fonte única)
└── CLAUDE.md                # importa AGENTS.md
```

## Começando

Pré-requisitos: [proto](https://moonrepo.dev/proto) (ou moon 2.6.5 instalado
por outro meio, como `npm i -g @moonrepo/cli@2.6.5`). Para as tarefas Python,
`ruff` e `pytest` no PATH.

```bash
proto use                          # instala as versões do .prototools
moon query projects                # lista os projetos
moon run exemplo-saudacao:test     # roda uma tarefa de um projeto
moon run :lint                     # roda lint em todos os projetos
moon ci                            # roda só o que mudou, como no CI
```

### Criar uma slice

```bash
moon generate slice
# ou sem prompts:
moon generate slice -- --dominio pedidos --feature checkout --linguagem python
moon run pedidos-checkout:test
```

## Usar em outro repositório

```bash
git clone https://github.com/vetryak/moon-base
./moon-base/scripts/adopt.sh ../vetryak-demos-hub
```

O script não sobrescreve arquivos existentes (use `--force` para atualizar) e
grava a versão aplicada em `.moon/moon-base.version`. Para receber atualizações
das tarefas sem copiar, use `extends` apontando para uma tag deste repositório.
Detalhes em [docs/reuso.md](docs/reuso.md).

## Convenções em resumo

| Item | Regra |
|------|-------|
| Pastas e ids | kebab-case; slice = `<dominio>-<feature>` |
| `layer` | `application` (apps), `library` (slices, libs), `configuration` (infra), `tool` (tools) |
| Tags | `slice`, `dominio-<nome>`, `terraform`, `container`, `cliente-<nome>`, `demo` |
| Tarefas | `lint`, `format-check`, `test`, `typecheck`, `build`, `tf-fmt`, `tf-validate`, `image-build` |
| Toolchain | só `system` no template |
| Segredos | nunca no repositório; GCP via Workload Identity Federation |

Referência completa em [docs/convencoes.md](docs/convencoes.md). Decisões de
arquitetura ficam em [docs/adr/](docs/adr/).

## Agentes de IA

`AGENTS.md` concentra as instruções para qualquer agente (Claude, Gemini,
Codex, Copilot, Cursor). Veja [docs/agentes-llm.md](docs/agentes-llm.md).
