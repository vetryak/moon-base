# infra/

Infraestrutura compartilhada pelo repositório (projeto GCP, rede, IAM,
Artifact Registry, Workload Identity Federation para o CI).
Infra específica de uma feature fica dentro da própria slice.

```
infra/<nome>/moon.yml  # layer: configuration; tags: [terraform]
```
