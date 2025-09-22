import 'dart:convert';

import 'package:posto360/modules/core/domain/utils/enums/aula_status.dart';

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
  final int duracao;

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
    required this.duracao,
  });

  bool get hasMaterial => urlMaterial != '';

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
      duracao: map['duracao'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AulaModel.fromJson(String source) =>
      AulaModel.fromMap(json.decode(source));

  AulaModel copyWith({
    int? id,
    int? templateId,
    String? titulo,
    String? descricao,
    String? urlVideo,
    String? urlMaterial,
    String? capa,
    int? ordem,
    AulaStatus? status,
    int? duracao,
  }) {
    return AulaModel(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      urlVideo: urlVideo ?? this.urlVideo,
      urlMaterial: urlMaterial ?? this.urlMaterial,
      capa: capa ?? this.capa,
      ordem: ordem ?? this.ordem,
      status: status ?? this.status,
      duracao: duracao ?? this.duracao,
    );
  }
}
