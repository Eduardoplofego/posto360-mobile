import 'dart:convert';

class ChecklistAnswerModel {
  final String descricao;
  final String? resposta;
  final bool respostaDada;
  final int checklistId;
  final int gestaoChecklistId;
  final String? fotoUrl;
  final String? observacoes;
  final String usuarioId;
  final bool necessitaRevisao;
  final List<String>? opcoes;

  ChecklistAnswerModel({
    required this.descricao,
    this.resposta,
    required this.respostaDada,
    required this.checklistId,
    required this.gestaoChecklistId,
    this.fotoUrl,
    this.observacoes,
    required this.usuarioId,
    required this.necessitaRevisao,
    this.opcoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'resposta': resposta,
      'respostaDada': respostaDada,
      'checklistId': checklistId,
      'gestaoChecklistId': gestaoChecklistId,
      'fotoUrl': fotoUrl,
      'observacoes': observacoes,
      'usuarioId': usuarioId,
      'NecessitaRevisao': necessitaRevisao,
      'opcoes': opcoes,
    };
  }

  factory ChecklistAnswerModel.fromMap(Map<String, dynamic> map) {
    return ChecklistAnswerModel(
      descricao: map['descricao'] ?? '',
      resposta: map['resposta'],
      respostaDada: map['respostaDada'] ?? false,
      checklistId: map['checklistId']?.toInt() ?? 0,
      gestaoChecklistId: map['gestaoChecklistId']?.toInt() ?? 0,
      fotoUrl: map['fotoUrl'],
      observacoes: map['observacoes'],
      usuarioId: map['usuarioId'] ?? '',
      necessitaRevisao: map['NecessitaRevisao'] ?? false,
      opcoes: map['opcoes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistAnswerModel.fromJson(String source) =>
      ChecklistAnswerModel.fromMap(json.decode(source));
}
