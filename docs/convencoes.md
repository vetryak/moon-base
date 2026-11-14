# Convenções

Estas convenções valem para o `moon-base` e para todo repositório que o adotar
(`vetryak-demos-hub`, `vetryak-docs-hub` e projetos de clientes).

## Versões

| Ferramenta | Versão   | Onde está fixada |
|------------|----------|------------------|
| moon       | 2.6.5    | `.prototools` (e `versionConstraint: ">=2.0.0"` no workspace) |
| node       | 22.11.0  | `.prototools` |

Atualize as versões aqui primeiro e propague com `scripts/adopt.sh --force`.

## Layout (VSA)

```
apps/<app>/                 layer: application    pontos de entrada implantáveis
slices/<dominio>/<feature>/ layer: library        fatias verticais autocontidas
libs/<lib>/                 layer: library        compartilhado (só com 2+ consumidores)
infra/<stack>/              layer: configuration  infraestrutura compartilhada
tools/<tool>/               layer: tool           scripts e utilitários internos
```

Uma **slice** contém tudo o que a feature precisa: código, testes, contratos
(OpenAPI/proto), prompts, infraestrutura própria e documentação. Ela não
importa código de outra slice; o que for comum vai para `libs/`, e a composição
acontece em `apps/`.

Repositórios que não são de código (como o `vetryak-docs-hub`) podem trocar os
globs de `projects` por algo como `["geral", "clientes/*/moon.yml"]`, mantendo
as mesmas regras de nomes e tags.

## Nomes

- Pastas e ids em **kebab-case**, sem acentos: `pedidos/checkout-rapido`.
- Id do projeto = `<dominio>-<feature>` para slices, `<nome>` para os demais.
- Módulos Python em snake_case (`checkout_rapido`), pacotes npm `@vetryak/<id>`.

## moon.yml de cada projeto

Campos obrigatórios: `id`, `language`, `layer`, `tags`, `project.title`,
`project.description`. Recomendado: `project.owner`, `stack`.

## Tags

| Tag              | Efeito |
|------------------|--------|
| `slice`          | marca o projeto como fatia vertical |
| `dominio-<nome>` | agrupa slices do mesmo domínio (`moon run '#dominio-pedidos:test'`) |
| `terraform`      | herda `tf-fmt` e `tf-validate` (`.moon/tasks/terraform.yml`) |
| `container`      | herda `image-build` (`.moon/tasks/container.yml`) |
| `cliente-<nome>` | identifica entregas de cliente (repositórios de cliente/docs) |
| `demo`           | identifica demos (vetryak-demos-hub) |

## Tarefas herdadas

| Arquivo                        | Quem herda                    | Tarefas |
|--------------------------------|-------------------------------|---------|
| `.moon/tasks/all.yml`          | todos                         | (fileGroups e opções padrão) |
| `.moon/tasks/python.yml`       | `language: python`            | lint, format-check, format, test |
| `.moon/tasks/node.yml`         | `language: javascript/typescript` | lint, typecheck, test, build, dev |
| `.moon/tasks/terraform.yml`    | tag `terraform`               | tf-fmt, tf-validate |
| `.moon/tasks/container.yml`    | tag `container`               | image-build |

Nomes de tarefas são padronizados (`lint`, `test`, `build`, `typecheck`,
`format-check`) para que `moon ci` e `moon run :test` funcionem igual em todo
repositório. Um projeto pode sobrescrever uma tarefa herdada declarando-a com o
mesmo nome no seu `moon.yml`.

## Toolchains

O template usa só o toolchain `system`: as ferramentas vêm do PATH (instaladas
pelo proto ou pelo CI). Plugins de toolchain do moon v2 são baixados de
`ghcr.io`, que pode estar bloqueado por proxy, então habilite-os apenas no
repositório que precisar (`.moon/toolchains.yml`).

## Segurança

- Nunca versionar segredos, chaves de service account, `.env` ou `*.tfvars` reais.
- CI autentica no Google Cloud via Workload Identity Federation (OIDC), sem chave JSON.
- Dados de clientes ficam fora do repositório; use dados sintéticos em demos.
