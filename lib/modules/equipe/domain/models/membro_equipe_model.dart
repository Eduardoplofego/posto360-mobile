class MembroEquipeModel {
  final String id;
  final String nome;
  final double nota;
  final double bonificacaoTotal;

  MembroEquipeModel({
    required this.id,
    required this.nome,
    required this.nota,
    required this.bonificacaoTotal,
  });

  factory MembroEquipeModel.fromMap(Map<String, dynamic> map) {
    return MembroEquipeModel(
      id: (map['id'] ?? '').toString(),
      nome: (map['nome'] ?? '').toString(),
      nota: (map['nota'] as num?)?.toDouble() ?? 0,
      bonificacaoTotal: (map['bonificacaoTotal'] as num?)?.toDouble() ?? 0,
    );
  }
}
