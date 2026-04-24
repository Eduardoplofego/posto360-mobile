class ResumoEquipeModel {
  final double mediaEquipe;
  final double penalidade;
  final int numeroUsuariosEquipe;

  ResumoEquipeModel({
    required this.mediaEquipe,
    required this.penalidade,
    required this.numeroUsuariosEquipe,
  });

  factory ResumoEquipeModel.empty() =>
      ResumoEquipeModel(mediaEquipe: 0, penalidade: 0, numeroUsuariosEquipe: 0);

  factory ResumoEquipeModel.fromMap(Map<String, dynamic> map) {
    return ResumoEquipeModel(
      mediaEquipe: (map['mediaEquipe'] as num?)?.toDouble() ?? 0,
      penalidade: (map['penalidade'] as num?)?.toDouble() ?? 0,
      numeroUsuariosEquipe: (map['numeroUsuariosEquipe'] as num?)?.toInt() ?? 0,
    );
  }
}
