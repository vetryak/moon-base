"""Slice de exemplo: regra de negócio isolada da feature "saudação"."""


def saudar(nome: str) -> str:
    """Retorna uma saudação para ``nome``."""
    nome = nome.strip() or "mundo"
    return f"Olá, {nome}!"
