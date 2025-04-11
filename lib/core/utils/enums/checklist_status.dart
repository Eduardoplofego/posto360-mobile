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
        return 'A aazer';
      case ChecklistStatus.emAndamento:
        return 'Em andamento';
      case ChecklistStatus.emRevisao:
        return 'Em revisão';
      case ChecklistStatus.finalizado:
        return 'Finalizado';
    }
  }
}
