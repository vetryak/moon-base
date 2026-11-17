# exemplo/saudacao

Slice de referência. Mostra a estrutura mínima de uma fatia vertical:

```
slices/exemplo/saudacao/
├── moon.yml          # identidade do projeto (id, language, layer, tags)
├── pyproject.toml
├── src/saudacao/     # código da feature (handler, regra, acesso a dados)
└── tests/            # testes da feature
```

```bash
moon run exemplo-saudacao:test
moon run exemplo-saudacao:lint
```
