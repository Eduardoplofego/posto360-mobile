class ProdutoMedicaoModel {
  final String nome;
  final double volumeMeiaNoite;
  final double volumeAtual;
  final double? capacidade;
  final DateTime? atualizadoEm;

  ProdutoMedicaoModel({
    required this.nome,
    required this.volumeMeiaNoite,
    required this.volumeAtual,
    required this.capacidade,
    required this.atualizadoEm,
  });

  double? get percentualOcupacao {
    if (capacidade == null || capacidade! <= 0) return null;
    final pct = volumeAtual / capacidade!;
    return pct.clamp(0.0, 1.0);
  }

  factory ProdutoMedicaoModel.fromMap(Map<String, dynamic> map) {
    final meiaNoite = map['volumeMeiaNoite'] as num? ?? 0;
    final atual = map['volumeAtual'] as num? ?? 0;
    final capacidadeRaw = map['capacidade'] as num?;
    final atualizadoEmRaw = map['atualizadoEm'] as String?;
    return ProdutoMedicaoModel(
      nome: map['nome'] as String? ?? '',
      volumeMeiaNoite: meiaNoite.toDouble(),
      volumeAtual: atual.toDouble(),
      capacidade: capacidadeRaw?.toDouble(),
      atualizadoEm:
          atualizadoEmRaw != null ? DateTime.parse(atualizadoEmRaw).toLocal() : null,
    );
  }
}
