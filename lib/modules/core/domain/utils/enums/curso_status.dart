import 'dart:developer';

import 'package:posto360/modules/core/domain/utils/status_text.dart';

enum CursoStatus { finalizado, andamento, naoIniciado }

extension GetCursoStatus on CursoStatus {
  static CursoStatus getStatus(dynamic status) {
    switch (StatusText.normalize(status)) {
      case 'finalizado':
      case 'concluido':
      case 'completo':
        return CursoStatus.finalizado;
      case 'em andamento':
      case 'andamento':
      case 'iniciado':
      case 'em progresso':
        return CursoStatus.andamento;
      case 'nao iniciado':
      case 'nao inciado':
      case 'pendente':
      case '':
        return CursoStatus.naoIniciado;
      default:
        log('Status de curso não reconhecido: "$status"');
        return CursoStatus.naoIniciado;
    }
  }

  String description() {
    switch (this) {
      case CursoStatus.finalizado:
        return 'Finalizado';
      case CursoStatus.andamento:
        return 'Em andamento';
      case CursoStatus.naoIniciado:
        return 'Não iniciado';
    }
  }
}
