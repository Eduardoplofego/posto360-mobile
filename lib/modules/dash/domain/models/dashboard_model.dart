class DashboardModel {
  int campanhasAtivas;
  double bonificacaoTotal;
  int totalCursos;
  int cursosConcluidos;
  double penalidadeCursos;
  int totalChecklist;
  int checklistsConcluidas;
  double penalidadeChecklists;

  DashboardModel({
    required this.campanhasAtivas,
    required this.bonificacaoTotal,
    required this.totalCursos,
    required this.cursosConcluidos,
    required this.totalChecklist,
    required this.checklistsConcluidas,
    required this.penalidadeCursos,
    required this.penalidadeChecklists,
  });

  factory DashboardModel.empty() {
    return DashboardModel(
      campanhasAtivas: 0,
      bonificacaoTotal: 0,
      totalCursos: 0,
      cursosConcluidos: 0,
      totalChecklist: 0,
      checklistsConcluidas: 0,
      penalidadeCursos: 0,
      penalidadeChecklists: 0,
    );
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      campanhasAtivas: map['campanhasAtivas'] ?? 0,
      bonificacaoTotal: (map['bonificacaoTotal'] as num?)?.toDouble() ?? 0,
      totalCursos: map['cursos']['total'] ?? 0,
      cursosConcluidos: map['cursos']['concluidos'] ?? 0,
      totalChecklist: map['checklist']['total'] ?? 0,
      checklistsConcluidas: map['checklist']['concluidos'] ?? 0,
      penalidadeCursos:
          double.tryParse(map['cursos']['penalidades'].toString()) ?? 0,
      penalidadeChecklists:
          double.tryParse(map['checklist']['penalidades'].toString()) ?? 0,
    );
  }
}
