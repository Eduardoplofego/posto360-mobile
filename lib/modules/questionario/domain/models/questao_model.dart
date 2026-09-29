import 'package:posto360/modules/questionario/domain/models/alternativa_model.dart';

class QuestaoModel {
  final int id;
  final String enunciado;
  final int ordem;

  /// já acertou em rodada anterior: mostrar respondida, não deixar mexer
  final bool bloqueada;

  /// é esta que a tela pinta de vermelho
  final bool erradaNaRodadaAnterior;

  /// alternativa que o usuário marcou por último, ou null se ainda não
  /// respondeu
  final int? alternativaMarcadaId;

  /// nunca traz `correta` — se algum dia trouxer, a prova acabou
  final List<AlternativaModel> alternativas;

  QuestaoModel({
    required this.id,
    required this.enunciado,
    required this.ordem,
    required this.bloqueada,
    required this.erradaNaRodadaAnterior,
    required this.alternativaMarcadaId,
    required this.alternativas,
  });

  factory QuestaoModel.fromMap(Map<String, dynamic> map) {
    return QuestaoModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      enunciado: map['enunciado'] ?? '',
      ordem: (map['ordem'] as num?)?.toInt() ?? 0,
      bloqueada: map['bloqueada'] == true,
      erradaNaRodadaAnterior: map['erradaNaRodadaAnterior'] == true,
      alternativaMarcadaId: (map['alternativaMarcadaId'] as num?)?.toInt(),
      alternativas:
          ((map['alternativas'] as List?) ?? [])
              .map(
                (a) => AlternativaModel.fromMap(Map<String, dynamic>.from(a)),
              )
              .toList(),
    );
  }
}
