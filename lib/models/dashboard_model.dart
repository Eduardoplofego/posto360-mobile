import 'dart:convert';

class DashboardModel {
  final int quantidadeCampanhas;
  final int realizadoCampanhas;
  final int totalCursos;
  final int cursosConcluidos;
  final int totalChecklist;
  final int checklistsConcluidas;

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
      quantidadeCampanhas: map['quantidadeCampanhas']?.toInt() ?? 0,
      realizadoCampanhas: map['realizadoCampanha']?.toInt() ?? 0.0,
      totalCursos: map['totalCursos']?.toInt() ?? 0,
      cursosConcluidos: map['cursosConcluidos']?.toInt() ?? 0,
      totalChecklist: map['totalChecklist']?.toInt() ?? 0,
      checklistsConcluidas: map['checklistsConcluidas']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) =>
      DashboardModel.fromMap(json.decode(source));
}
