# ADR 0001: moon v2 com Vertical Slice Architecture

- **Status:** aceito
- **Data:** 2026-11-14

## Contexto

A Vetryak mantém vários repositórios (demos, docs, entregas de clientes) e quer
CI rápido e padronizado. Os repositórios são monorepos e precisam de uma forma
de rodar só o que mudou.

## Decisão

- Usar **moon v2** (2.6.5) como orquestrador de tarefas, com versão fixada via proto.
- Organizar código por **fatias verticais** (`slices/<dominio>/<feature>`), e não por camada técnica.
- Usar apenas o toolchain `system`; plugins de toolchain ficam opcionais por repositório.
- Distribuir o template por cópia (`scripts/adopt.sh`), com `extends` por URL como alternativa.

## Consequências

- `moon ci` roda apenas projetos afetados, com cache por hash de inputs.
- Cada slice pode ser entregue, demonstrada ou removida de forma isolada.
- Ferramentas (ruff, pytest, terraform, docker) precisam estar no PATH ou no CI.
