class PassoModel {
  final int id;
  final String descricao;
  final int ordem;
  final String? imagem;
  final bool atencao;
  final int etapaId;
  final int procedimentoId;

  PassoModel({
    required this.id,
    required this.descricao,
    required this.ordem,
    required this.imagem,
    required this.atencao,
    required this.etapaId,
    required this.procedimentoId,
  });

  factory PassoModel.fromMap(Map<String, dynamic> map) {
    return PassoModel(
      id: map['id']?.toInt() ?? 0,
      descricao: map['Descricao'] ?? '',
      ordem: map['Ordem']?.toInt() ?? 0,
      imagem: map['Imagem'],
      atencao: map['Atencao'] == true,
      etapaId: map['EtapaId']?.toInt() ?? 0,
      procedimentoId: map['ProcedimentoId']?.toInt() ?? 0,
    );
  }
}
