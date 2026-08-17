import 'dart:developer';

import 'package:posto360/modules/core/domain/utils/status_text.dart';

enum AulaStatus { finalizado, emAndamento, bloqueado }

extension GetAulaStatus on AulaStatus {
  static AulaStatus getStatus(dynamic status) {
    switch (StatusText.normalize(status)) {
      case 'finalizado':
      case 'concluido':
      case 'completo':
        return AulaStatus.finalizado;
      case 'em andamento':
      case 'andamento':
      case 'iniciado':
      case 'em progresso':
      case 'nao iniciado':
      case 'nao inciado':
      case 'pendente':
      case 'liberado':
      case 'disponivel':
        return AulaStatus.emAndamento;
      case 'bloqueado':
      case '':
        return AulaStatus.bloqueado;
      default:
        log('Status de aula não reconhecido: "$status"');
        return AulaStatus.bloqueado;
    }
  }

  String description() {
    switch (this) {
      case AulaStatus.finalizado:
        return 'Finalizado';
      case AulaStatus.emAndamento:
        return 'Em andamento';
      case AulaStatus.bloqueado:
        return 'Bloqueado';
    }
  }
}
