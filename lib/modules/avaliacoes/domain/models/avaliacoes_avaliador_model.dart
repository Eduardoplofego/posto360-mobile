abstract class AvaliacaoAvaliador {
  final int id;
  final String nome;
  final String descricao;
  final int numeroCriterios;

  AvaliacaoAvaliador({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.numeroCriterios,
  });
}

class AvaliacaoFinalizada extends AvaliacaoAvaliador {
  final int criteriosCumpridos;
  final double penalidade;
  final String avaliador;
  final DateTime dataAvaliacao;

  AvaliacaoFinalizada({
    required super.id,
    required super.nome,
    required super.descricao,
    required super.numeroCriterios,
    required this.criteriosCumpridos,
    required this.penalidade,
    required this.avaliador,
    required this.dataAvaliacao,
  });

  factory AvaliacaoFinalizada.fromMap(Map<String, dynamic> map) {
    return AvaliacaoFinalizada(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      numeroCriterios: map['numeroCriterios'],
      criteriosCumpridos: map['criteriosCumpridos'],
      penalidade: map['penalidade'],
      avaliador: map['avaliador'],
      dataAvaliacao: DateTime.parse(map['dataAvaliacao']),
    );
  }
}

class AvaliacaoPendente extends AvaliacaoAvaliador {
  final int numModelo;
  final DateTime? prazo;
  final String status;
  final String? avaliadoId;

  AvaliacaoPendente({
    required super.id,
    required super.nome,
    required super.descricao,
    required super.numeroCriterios,
    required this.numModelo,
    required this.prazo,
    required this.status,
    required this.avaliadoId,
  });

  factory AvaliacaoPendente.fromMap(Map<String, dynamic> map) {
    final criterios = map['criterios'] as List;

    return AvaliacaoPendente(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      numeroCriterios: criterios.length,
      numModelo: map['modeloId'],
      status: map['status'],
      avaliadoId: map['idAvaliado'],
      prazo: DateTime.tryParse(map['dataConclusao'] ?? ''),
    );
  }
}
