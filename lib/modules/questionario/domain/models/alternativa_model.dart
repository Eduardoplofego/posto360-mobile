class AlternativaModel {
  final int id;
  final String texto;
  final int ordem;

  AlternativaModel({
    required this.id,
    required this.texto,
    required this.ordem,
  });

  factory AlternativaModel.fromMap(Map<String, dynamic> map) {
    return AlternativaModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      texto: map['texto'] ?? '',
      ordem: (map['ordem'] as num?)?.toInt() ?? 0,
    );
  }
}
