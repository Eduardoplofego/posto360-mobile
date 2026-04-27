class PenalidadeModel {
  final int id;
  final DateTime data;
  final String tipo;
  final num penalidade;

  PenalidadeModel({
    required this.id,
    required this.data,
    required this.tipo,
    required this.penalidade,
  });

  factory PenalidadeModel.fromMap(Map<String, dynamic> map) {
    return PenalidadeModel(
      id: map['id'] as int,
      data: DateTime.parse(map['data'] as String),
      tipo: map['tipo'] as String,
      penalidade: (map['penalidade'] as num?) ?? 0,
    );
  }
}

class DiaPenalidades {
  final Map<String, double> porTipo;

  const DiaPenalidades({required this.porTipo});

  factory DiaPenalidades.empty() => const DiaPenalidades(porTipo: {});

  double get total => porTipo.values.fold(0.0, (s, v) => s + v);
  bool get hasPenalidade => total < 0;
}
