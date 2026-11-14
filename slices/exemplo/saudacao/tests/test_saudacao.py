from saudacao import saudar


def test_saudar_nome():
    assert saudar("Vetryak") == "Olá, Vetryak!"


def test_saudar_vazio():
    assert saudar("  ") == "Olá, mundo!"
