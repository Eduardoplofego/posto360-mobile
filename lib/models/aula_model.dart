import 'dart:convert';

import 'package:posto360/core/utils/enums/aula_status.dart';

class AulaModel {
  final int id;
  final int templateId;
  final String titulo;
  final String descricao;
  final String urlVideo;
  final String urlMaterial;
  final String capa;
  final int ordem;
  final AulaStatus status;

  AulaModel({
    required this.id,
    required this.templateId,
    required this.titulo,
    required this.descricao,
    required this.urlVideo,
    required this.urlMaterial,
    required this.capa,
    required this.ordem,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'templateId': templateId,
      'titulo': titulo,
      'descricao': descricao,
      'urlVideo': urlVideo,
      'urlMaterial': urlMaterial,
      'capa': capa,
      'ordem': ordem,
      'status': status.description(),
    };
  }

  factory AulaModel.fromMap(Map<String, dynamic> map) {
    return AulaModel(
      id: map['id']?.toInt() ?? 0,
      templateId: map['templateId']?.toInt() ?? 0,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      urlVideo: map['videoUrl'] ?? '',
      urlMaterial: map['materialComplementar'] ?? '',
      capa: map['capa'] ?? '',
      ordem: map['ordem']?.toInt() ?? 0,
      status: GetAulaStatus.getStatus(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AulaModel.fromJson(String source) =>
      AulaModel.fromMap(json.decode(source));
}
