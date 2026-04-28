class AvaliacoesModel {
  final int id;
  final String nome;
  final String descricao;
  final int modeloId;
  final DateTime? dataConclusao;
  final String comentarios;
  final String avaliador;
  final int numeroCriterios;
  final int criteriosCumpridos;
  final double penalidade;

  bool get isConcluded => criteriosCumpridos == numeroCriterios;

  AvaliacoesModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.modeloId,
    required this.dataConclusao,
    required this.comentarios,
    required this.avaliador,
    required this.numeroCriterios,
    required this.criteriosCumpridos,
    required this.penalidade,
  });

  factory AvaliacoesModel.fromJson(Map<String, dynamic> json) {
    return AvaliacoesModel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      modeloId: json['modeloId'],
      dataConclusao: DateTime.tryParse(json['dataConclusao']),
      comentarios: json['comentarios'] ?? '',
      avaliador: json['avaliador'],
      numeroCriterios: json['numeroCriterios'],
      criteriosCumpridos: json['criteriosCumpridos'],
      penalidade: (json['penalidade'] as num).toDouble(),
    );
  }
}
