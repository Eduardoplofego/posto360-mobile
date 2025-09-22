enum ChecklistStatus { aFazer, emAndamento, emRevisao, finalizado }

extension GetChecklistStatus on ChecklistStatus {
  static ChecklistStatus getStatus(String status) {
    switch (status) {
      case 'A Fazer':
        return ChecklistStatus.aFazer;
      case 'Em Andamento':
        return ChecklistStatus.emAndamento;
      case 'Em Revisão':
        return ChecklistStatus.emRevisao;
      default:
        return ChecklistStatus.finalizado;
    }
  }

  String description() {
    switch (this) {
      case ChecklistStatus.aFazer:
        return 'A Fazer';
      case ChecklistStatus.emAndamento:
        return 'Em Andamento';
      case ChecklistStatus.emRevisao:
        return 'Em Revisão';
      case ChecklistStatus.finalizado:
        return 'Finalizado';
    }
  }
}
