# libs/

Código compartilhado por **várias** slices (clientes de API, logging,
autenticação). Regra: só promova algo para `libs/` quando pelo menos duas
slices precisarem dele. Duplicação pequena é preferível a acoplamento.

```
libs/<nome>/moon.yml   # layer: library
```
