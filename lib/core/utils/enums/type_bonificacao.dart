enum TypeBonificacao { valor, unidade }

extension TypeBonificacaoDescription on TypeBonificacao {
  String description() {
    switch (this) {
      case TypeBonificacao.valor:
        return 'Valor';
      case TypeBonificacao.unidade:
        return 'Unidade';
    }
  }
}
