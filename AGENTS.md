# AGENTS.md

Instruções para agentes de IA (Claude, Gemini, Codex, Copilot, Cursor e outros)
que trabalham neste repositório. Este arquivo é a fonte única; `CLAUDE.md`,
`.gemini/settings.json` e `.github/copilot-instructions.md` apontam para cá.

## O que é este repositório

`moon-base` é o **template moonrepo da Vetryak**. Ele não contém produto: define
a configuração do moon (workspace, tarefas herdadas, gerador de slices), o
layout VSA e as convenções reutilizadas por `vetryak-demos-hub`,
`vetryak-docs-hub` e repositórios de clientes. Mudanças aqui afetam todos eles.

## Mapa

```
.moon/workspace.yml      projetos, VCS, pipeline, gerador
.moon/toolchains.yml     só "system" por padrão (plugins comentados)
.moon/tasks/*.yml        tarefas herdadas (all, python, node, terraform, container)
templates/slice/         template do `moon generate slice`
slices/exemplo/saudacao/ slice de referência (smoke test do template)
apps/ libs/ infra/ tools/  pastas do layout VSA (README explica cada uma)
scripts/adopt.sh         aplica o template em outro repositório
docs/                    convenções, reuso, agentes, ADRs
```

## Comandos

```bash
proto use                                   # instala moon 2.6.5 e node 22.11.0
moon query projects                         # lista projetos
moon run exemplo-saudacao:test              # roda uma tarefa
moon run :lint                              # roda lint em todos os projetos
moon ci                                     # roda o que foi afetado (igual ao CI)
moon generate slice -- --dominio x --feature y --linguagem python
./scripts/adopt.sh ../outro-repo            # aplica o template
```

## Regras

1. **Português (BR)** em documentação, comentários de configuração e mensagens de commit.
2. **moon v2**: use `layer` (não `type`), `vcs.client`, `.moon/toolchains.yml`,
   `inheritedBy` nos arquivos de `.moon/tasks/`. Não use sintaxe do moon v1.
3. **Toolchain `system`** nas tarefas herdadas. Não adicione plugins de
   toolchain aqui (dependem de `ghcr.io`, bloqueado em alguns ambientes).
4. **Nomes de tarefas padronizados**: `lint`, `format-check`, `format`, `test`,
   `typecheck`, `build`, `dev`, `tf-fmt`, `tf-validate`, `image-build`.
   Não renomeie: outros repositórios dependem deles.
5. **VSA**: uma slice não importa outra slice. Código comum vai para `libs/`
   apenas com dois ou mais consumidores; composição acontece em `apps/`.
6. **Kebab-case** em pastas e ids. Id de slice = `<dominio>-<feature>`.
7. **Segurança**: nunca versionar segredos, chaves de service account, `.env`,
   `*.tfvars` reais ou dados de clientes. Autenticação no GCP via Workload
   Identity Federation.
8. Ao mudar convenção, atualize `docs/convencoes.md`, este arquivo e o README
   no mesmo PR, e registre decisões relevantes em `docs/adr/`.

## Antes de concluir uma tarefa

- `moon ci` passa (ou ao menos `moon run :lint :test`).
- `moon generate slice` continua gerando uma slice válida, se você mexeu em `templates/`.
- `scripts/adopt.sh` em um diretório vazio funciona, se você mexeu na lista de arquivos copiados.
