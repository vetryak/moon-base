# Instruções para agentes de IA (multi-LLM)

O `AGENTS.md` na raiz é a **fonte única** de instruções para qualquer agente.
Os demais arquivos apenas apontam para ele, para evitar instruções divergentes.

| Ferramenta          | Arquivo lido                       | Como está configurado |
|---------------------|------------------------------------|-----------------------|
| Codex, Cursor, Jules, Amp, outras | `AGENTS.md`          | nativo |
| Claude Code         | `CLAUDE.md`                        | importa `@AGENTS.md` + notas específicas |
| Gemini CLI / Gemini Code Assist | `.gemini/settings.json`  | `context.fileName: ["AGENTS.md"]` |
| GitHub Copilot      | `.github/copilot-instructions.md`  | aponta para `AGENTS.md` |

O `scripts/adopt.sh` copia os três ponteiros; escreva só o `AGENTS.md` com o
contexto do repositório que adotou o template. Slices podem ter
um `AGENTS.md` próprio quando tiverem regras locais; agentes que suportam
arquivos aninhados usam o mais próximo do arquivo editado.
