enum AulaStatus { finalizado, emAndamento, bloqueado }

extension GetAulaStatus on AulaStatus {
  static AulaStatus getStatus(String status) {
    switch (status) {
      case 'Finalizado':
        return AulaStatus.finalizado;
      case 'Em andamento' || 'Não Iniciado':
        return AulaStatus.emAndamento;
      default:
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
