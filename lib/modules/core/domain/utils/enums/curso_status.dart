enum CursoStatus { finalizado, andamento, naoIniciado }

extension GetCursoStatus on CursoStatus {
  static CursoStatus getStatus(String status) {
    switch (status) {
      case 'Finalizado':
        return CursoStatus.finalizado;
      case 'Em andamento':
        return CursoStatus.andamento;
      default:
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
