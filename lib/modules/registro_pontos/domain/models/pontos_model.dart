import 'dart:convert';

class PontosModel {
  final DateTime data;
  final List<String> pontos;

  PontosModel({required this.data, required this.pontos});

  String getTotalWorkHours() {
    if (pontos.any((ponto) => ponto.isEmpty)) {
      return '00:00';
    }
    Duration parseTime(String time) {
      final sanitizedEle = time.replaceAll(RegExp(r'[^\d:]'), '');
      final parts = sanitizedEle.split(':').map(int.parse).toList();
      return Duration(hours: parts[0], minutes: parts[1]);
    }

    final entrada1 = parseTime(pontos[0]);
    final saida1 = parseTime(pontos[1]);
    final entrada2 = parseTime(pontos[2]);
    final saida2 = parseTime(pontos[3]);

    final total = (saida1 - entrada1) + (saida2 - entrada2);

    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() {
    return {'data': data, 'pontos': pontos};
  }

  factory PontosModel.fromMap(Map<String, dynamic> map) {
    final entrada1 = map['entrada1Batida'];
    final entrada2 = map['entrada2Batida'];
    final saida1 = map['saida1Batida'];
    final saida2 = map['saida2Batida'];
    return PontosModel(
      data: DateTime.tryParse(map['data']) ?? DateTime.now(),
      pontos: [entrada1, saida1, entrada2, saida2],
    );
  }

  String toJson() => json.encode(toMap());

  factory PontosModel.fromJson(String source) =>
      PontosModel.fromMap(json.decode(source));
}
