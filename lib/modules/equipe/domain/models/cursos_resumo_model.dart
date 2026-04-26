class CursosResumoModel {
  final int total;
  final int concluidos;
  final double penalidades;

  CursosResumoModel({
    required this.total,
    required this.concluidos,
    required this.penalidades,
  });

  factory CursosResumoModel.empty() =>
      CursosResumoModel(total: 0, concluidos: 0, penalidades: 0);

  factory CursosResumoModel.fromMap(Map<String, dynamic> map) {
    final cursos = map['cursos'];
    if (cursos is! Map<String, dynamic>) return CursosResumoModel.empty();
    return CursosResumoModel(
      total: (cursos['total'] as num?)?.toInt() ?? 0,
      concluidos: (cursos['concluidos'] as num?)?.toInt() ?? 0,
      penalidades: (cursos['penalidades'] as num?)?.toDouble() ?? 0,
    );
  }
}
