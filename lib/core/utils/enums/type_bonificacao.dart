enum TypeBonificacao { valor, unidade }

extension TypeBonificacaoDescription on TypeBonificacao {
  String description() {
    switch (this) {
      case TypeBonificacao.valor:
        return 'VALOR';
      case TypeBonificacao.unidade:
        return 'UNIDADE';
    }
  }
}
