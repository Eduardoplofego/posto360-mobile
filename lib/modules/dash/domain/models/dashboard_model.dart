import 'dart:convert';

class DashboardModel {
  int quantidadeCampanhas;
  int realizadoCampanhas;
  int totalCursos;
  int cursosConcluidos;
  int totalChecklist;
  int checklistsConcluidas;

  DashboardModel({
    required this.quantidadeCampanhas,
    required this.realizadoCampanhas,
    required this.totalCursos,
    required this.cursosConcluidos,
    required this.totalChecklist,
    required this.checklistsConcluidas,
  });

  factory DashboardModel.empty() {
    return DashboardModel(
      quantidadeCampanhas: 0,
      realizadoCampanhas: 0,
      totalCursos: 0,
      cursosConcluidos: 0,
      totalChecklist: 0,
      checklistsConcluidas: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'realizadoCampanhas': realizadoCampanhas,
      'totalCursos': totalCursos,
      'cursosConcluidos': cursosConcluidos,
      'totalChecklist': totalChecklist,
      'checklistsConcluidas': checklistsConcluidas,
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      quantidadeCampanhas: map['quantidadeCampanhas'] ?? 0,
      realizadoCampanhas: map['realizadoCampanha'] ?? 0,

      totalCursos: map['cursos']['total'] ?? 0,
      cursosConcluidos: map['cursos']['concluidos'] ?? 0,
      totalChecklist: map['checklists']['total'] ?? 0,
      checklistsConcluidas: map['checklists']['concluidos'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) =>
      DashboardModel.fromMap(json.decode(source));
}
