import 'package:posto360/modules/questionario/domain/models/questao_model.dart';

/// Representa a resposta de GET /questionario nos dois formatos possíveis:
/// liberada (com as questões) ou travada (com o motivo do bloqueio).
class QuestionarioModel {
  final bool liberado;

  /// só vem preenchido quando liberado == false: 'aulas-pendentes' ou
  /// 'sem-questionario'
  final String? motivo;
  final int? aulasPendentes;

  /// 'Não Iniciado' | 'Em Correção' | 'Aprovado'
  final String? situacao;
  final num? notaMinima;

  /// rodada que o usuário vai responder agora
  final int? rodada;

  /// null enquanto a 1ª rodada não foi corrigida
  final num? notaAtual;

  final List<QuestaoModel> questoes;

  QuestionarioModel({
    required this.liberado,
    required this.motivo,
    required this.aulasPendentes,
    required this.situacao,
    required this.notaMinima,
    required this.rodada,
    required this.notaAtual,
    required this.questoes,
  });

  /// false só quando o curso não tem prova cadastrada. Quando a prova existe
  /// mas está bloqueada por aulas pendentes, continua true.
  bool get existeProva => motivo != 'sem-questionario';

  bool get aprovado => situacao == 'Aprovado';

  factory QuestionarioModel.fromMap(Map<String, dynamic> map) {
    final liberado = map['liberado'] == true;

    return QuestionarioModel(
      liberado: liberado,
      motivo: map['motivo'] as String?,
      aulasPendentes: (map['aulasPendentes'] as num?)?.toInt(),
      situacao: map['situacao'] as String?,
      notaMinima: map['notaMinima'] as num?,
      rodada: (map['rodada'] as num?)?.toInt(),
      notaAtual: map['notaAtual'] as num?,
      questoes:
          liberado
              ? ((map['questoes'] as List?) ?? [])
                  .map(
                    (q) => QuestaoModel.fromMap(Map<String, dynamic>.from(q)),
                  )
                  .toList()
              : <QuestaoModel>[],
    );
  }
}
