class ChecklistsResumoModel {
  final int total;
  final int concluidos;
  final double penalidades;

  ChecklistsResumoModel({
    required this.total,
    required this.concluidos,
    required this.penalidades,
  });

  factory ChecklistsResumoModel.empty() =>
      ChecklistsResumoModel(total: 0, concluidos: 0, penalidades: 0);

  factory ChecklistsResumoModel.fromMap(Map<String, dynamic> map) {
    final checklist = map['checklist'];
    if (checklist is! Map<String, dynamic>) {
      return ChecklistsResumoModel.empty();
    }
    return ChecklistsResumoModel(
      total: (checklist['total'] as num?)?.toInt() ?? 0,
      concluidos: (checklist['concluidos'] as num?)?.toInt() ?? 0,
      penalidades: (checklist['penalidades'] as num?)?.toDouble() ?? 0,
    );
  }
}
