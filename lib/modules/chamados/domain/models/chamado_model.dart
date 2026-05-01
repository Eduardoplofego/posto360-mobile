import 'package:flutter/material.dart';

class ChamadoFilialModel {
  final int id;
  final String nome;
  final String cor;

  ChamadoFilialModel({
    required this.id,
    required this.nome,
    required this.cor,
  });

  factory ChamadoFilialModel.fromMap(Map<String, dynamic> map) {
    return ChamadoFilialModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      cor: map['cor'] ?? '#1C47C7',
    );
  }
}

class ChamadoUsuarioModel {
  final String id;
  final String nome;
  final String tipo;
  final ChamadoFilialModel? filial;

  ChamadoUsuarioModel({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.filial,
  });

  factory ChamadoUsuarioModel.fromMap(Map<String, dynamic> map) {
    final filialRaw = map['filial'];
    return ChamadoUsuarioModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
      filial: filialRaw is Map<String, dynamic>
          ? ChamadoFilialModel.fromMap(filialRaw)
          : null,
    );
  }
}

class ChamadoModel {
  final int id;
  final String nomeTemplate;
  final String descricaoTemplate;
  final String corTemplate;
  final String titulo;
  final String status;
  final DateTime? dataDesignacao;
  final DateTime? dataValidade;
  final ChamadoUsuarioModel? abertoPor;
  final ChamadoUsuarioModel? responsavel;
  final int totalCampos;
  final int camposRespondidos;

  ChamadoModel({
    required this.id,
    required this.nomeTemplate,
    required this.descricaoTemplate,
    required this.corTemplate,
    required this.titulo,
    required this.status,
    required this.dataDesignacao,
    required this.dataValidade,
    required this.abertoPor,
    required this.responsavel,
    required this.totalCampos,
    required this.camposRespondidos,
  });

  Color get color {
    final hex = corTemplate.replaceAll('#', '');
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return const Color(0xFF1C47C7);
    return Color(0xFF000000 | value);
  }

  bool get isCompleto => totalCampos > 0 && camposRespondidos >= totalCampos;

  factory ChamadoModel.fromMap(Map<String, dynamic> map) {
    final abertoPorRaw = map['abertoPor'];
    final responsavelRaw = map['responsavel'];
    return ChamadoModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      nomeTemplate: map['nomeTemplate'] ?? '',
      descricaoTemplate: map['descricaoTemplate'] ?? '',
      corTemplate: map['corTemplate'] ?? '#1C47C7',
      titulo: map['titulo'] ?? '',
      status: map['status'] ?? '',
      dataDesignacao: map['dataDesignacao'] != null
          ? DateTime.tryParse(map['dataDesignacao'].toString())
          : null,
      dataValidade: map['dataValidade'] != null
          ? DateTime.tryParse(map['dataValidade'].toString())
          : null,
      abertoPor: abertoPorRaw is Map<String, dynamic>
          ? ChamadoUsuarioModel.fromMap(abertoPorRaw)
          : null,
      responsavel: responsavelRaw is Map<String, dynamic>
          ? ChamadoUsuarioModel.fromMap(responsavelRaw)
          : null,
      totalCampos: (map['totalCampos'] as num?)?.toInt() ?? 0,
      camposRespondidos: (map['camposRespondidos'] as num?)?.toInt() ?? 0,
    );
  }
}
