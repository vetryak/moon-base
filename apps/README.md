# apps/

Pontos de entrada implantáveis (API, UI, job, agente). Um app **compõe**
slices: ele cuida de bootstrap, roteamento, configuração e deploy, e não
contém regra de negócio.

```
apps/<nome>/moon.yml   # layer: application; dependsOn: [<slices usadas>]
```
