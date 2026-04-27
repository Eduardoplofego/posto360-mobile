class AvaliacaoDetailsModel {
  final int id;
  final DateTime? dataPreenchimento;
  final bool cumprido;
  final double penalidade;
  final String? comentarios;
  final String nome;
  final String descricao;
  final int criterioModeloId;

  AvaliacaoDetailsModel({
    required this.id,
    required this.dataPreenchimento,
    required this.cumprido,
    required this.penalidade,
    required this.comentarios,
    required this.nome,
    required this.descricao,
    required this.criterioModeloId,
  });

  factory AvaliacaoDetailsModel.fromMap(Map<String, dynamic> map) {
    return AvaliacaoDetailsModel(
      id: map['id'] as int,
      dataPreenchimento:
          map['dataPreenchimento'] != null
              ? DateTime.parse(map['dataPreenchimento'])
              : null,
      cumprido: map['cumprido'] as bool,
      penalidade: (map['penalidade'] as num).toDouble(),
      comentarios: map['comentarios'] as String?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
      criterioModeloId: map['criterioModeloId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPreenchimento': dataPreenchimento?.toIso8601String(),
      'cumprido': cumprido,
      'penalidade': penalidade,
      'comentarios': comentarios,
      'nome': nome,
      'descricao': descricao,
      'criterioModeloId': criterioModeloId,
    };
  }
}
