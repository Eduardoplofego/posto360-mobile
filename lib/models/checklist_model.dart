import 'dart:convert';

import 'package:posto360/core/utils/enums/checklist_status.dart';

class ChecklistModel {
  final int id;
  final String name;
  final String description;
  final int totalChecks;
  final int concludedChecks;
  final ChecklistStatus status;
  final String usuarioId;
  final int filialId;

  ChecklistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.usuarioId,
    required this.filialId,
    required this.totalChecks,
    required this.concludedChecks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'totalChecks': totalChecks,
      'concludedChecks': concludedChecks,
      'status': status.description(),
      'usuarioId': usuarioId,
      'filialId': filialId,
    };
  }

  factory ChecklistModel.fromMap(Map<String, dynamic> map) {
    final totalConcludedChecks = map['respostasConcluidas'] ?? 0;
    final totalChecks = map['totalRespostas'] ?? 0;
    return ChecklistModel(
      id: map['checklistId']?.toInt() ?? 0,
      name: map['nomeChecklist'] ?? '',
      description: map['description'] ?? '',
      totalChecks: totalChecks,
      concludedChecks: totalConcludedChecks,
      status: GetChecklistStatus.getStatus(map['status']),
      usuarioId: map['usuarioId'] ?? '',
      filialId: map['filialId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistModel.fromJson(String source) =>
      ChecklistModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChecklistModel(id: $id, name: $name, description: $description, totalChecks: $totalChecks, concludedChecks: $concludedChecks, status: $status, usuarioId: $usuarioId, filialId: $filialId)';
  }
}
