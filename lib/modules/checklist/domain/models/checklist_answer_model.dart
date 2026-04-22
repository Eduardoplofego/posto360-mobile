import 'dart:convert';

import 'package:posto360/modules/core/domain/utils/enums/checklist_answer_tipo.dart';

class ChecklistAnswerModel {
  final int id;
  final String descricao;
  final String? resposta;
  final ChecklistAnswerTipo tipo;
  final bool respostaDada;
  final int checklistId;
  final int gestaoChecklistId;
  final String? fotoUrl;
  final String? observacoes;
  final String usuarioId;
  final bool necessitaRevisao;
  final List<String>? opcoes;

  ChecklistAnswerModel({
    required this.id,
    required this.descricao,
    this.resposta,
    required this.respostaDada,
    required this.tipo,
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
      'id': id,
      'descricao': descricao,
      'resposta': resposta,
      'respostaDada': respostaDada,
      'tipo': ChecklistAnswerTipoDescription.getTipoString(tipo),
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
      id: map['id']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      resposta: map['resposta'],
      respostaDada: map['respostaDada'] ?? false,
      tipo: ChecklistAnswerTipoDescription.getTipo(map['tipo']),
      checklistId: map['checklistId']?.toInt() ?? 0,
      gestaoChecklistId: map['gestaoChecklistId']?.toInt() ?? 0,
      fotoUrl: map['fotoUrl'],
      observacoes: map['observacoes'],
      usuarioId: map['usuarioId'] ?? '',
      necessitaRevisao: map['NecessitaRevisao'] ?? false,
      opcoes: map['opcoes'] != null ? List<String>.from(map['opcoes']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistAnswerModel.fromJson(String source) =>
      ChecklistAnswerModel.fromMap(json.decode(source));
}
