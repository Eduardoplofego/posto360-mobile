import 'dart:convert';

import 'package:posto360/core/utils/enums/curso_status.dart';

class CursoModel {
  final int id;
  final int templateId;
  final String titulo;
  final String descricao;
  final String capa;
  final CursoStatus status;
  final String tipoUsuario;
  final int totalAulas;
  final int aulasConcluidas;
  final DateTime inscricao;
  final DateTime? ultimoAcesso;
  final bool certificadoEmitido;

  CursoModel({
    required this.id,
    required this.templateId,
    required this.titulo,
    required this.descricao,
    required this.capa,
    required this.status,
    required this.tipoUsuario,
    required this.totalAulas,
    required this.aulasConcluidas,
    required this.inscricao,
    required this.ultimoAcesso,
    required this.certificadoEmitido,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'templateId': templateId,
      'titulo': titulo,
      'descricao': descricao,
      'url': capa,
      'status': status.description(),
      'tipoUsuario': tipoUsuario,
    };
  }

  factory CursoModel.fromMap(Map<String, dynamic> map) {
    return CursoModel(
      id: map['id'] ?? 0,
      templateId: map['templateId'] ?? 0,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      capa: map['capa'] ?? '',
      status: GetCursoStatus.getStatus(map['status']),
      tipoUsuario: map['tipoUsuario'] ?? '',
      aulasConcluidas: map['aulasConcluidas'] ?? 0,
      totalAulas: map['totalAulas'] ?? 0,
      inscricao:
          map['dataInicio'] != null
              ? DateTime.parse(map['dataInicio'])
              : DateTime(1900),
      ultimoAcesso:
          map['ultimoAcesso'] != null
              ? DateTime.parse(map['ultimoAcesso'])
              : DateTime(1900),
      certificadoEmitido: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CursoModel.fromJson(String source) =>
      CursoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CursoModel(id: $id, templateId: $templateId, titulo: $titulo, descricao: $descricao, capa: $capa, status: $status, tipoUsuario: $tipoUsuario, totalAulas: $totalAulas, aulasConcluidas: $aulasConcluidas, inscricao: $inscricao, ultimoAcesso: $ultimoAcesso, certificadoEmitido: $certificadoEmitido)';
  }
}
