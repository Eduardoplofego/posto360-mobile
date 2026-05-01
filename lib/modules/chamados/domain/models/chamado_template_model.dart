import 'package:flutter/material.dart';

class ChamadoTemplateModel {
  final int id;
  final String nome;
  final String descricao;
  final String cor;

  ChamadoTemplateModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.cor,
  });

  Color get color {
    final hex = cor.replaceAll('#', '');
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return const Color(0xFF1C47C7);
    return Color(0xFF000000 | value);
  }

  factory ChamadoTemplateModel.fromMap(Map<String, dynamic> map) {
    return ChamadoTemplateModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      cor: map['cor'] ?? '#1C47C7',
    );
  }
}
