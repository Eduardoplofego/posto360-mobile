/// Resposta de POST /questionario/responder.
class CorrecaoModel {
  final bool aprovado;
  final num nota;
  final num notaMinima;

  /// rodada que acabou de ser corrigida
  final int rodada;

  /// null quando já aprovou: não há próxima rodada
  final int? proximaRodada;

  /// ids das questões erradas nesta correção, para pintar de vermelho
  final List<int> erradas;

  /// true quando aprovar fechou o curso inteiro (todas as aulas + prova)
  final bool cursoFinalizado;

  CorrecaoModel({
    required this.aprovado,
    required this.nota,
    required this.notaMinima,
    required this.rodada,
    required this.proximaRodada,
    required this.erradas,
    required this.cursoFinalizado,
  });

  factory CorrecaoModel.fromMap(Map<String, dynamic> map) {
    return CorrecaoModel(
      aprovado: map['aprovado'] == true,
      nota: map['nota'] as num? ?? 0,
      notaMinima: map['notaMinima'] as num? ?? 0,
      rodada: (map['rodada'] as num?)?.toInt() ?? 0,
      proximaRodada: (map['proximaRodada'] as num?)?.toInt(),
      erradas:
          ((map['erradas'] as List?) ?? [])
              .map((e) => (e as num).toInt())
              .toList(),
      cursoFinalizado: map['cursoFinalizado'] == true,
    );
  }
}
