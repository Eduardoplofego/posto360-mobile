class PontosModel {
  final String data;
  final List<String> pontos;

  PontosModel({required this.data, required this.pontos});

  String getTotalWorkHours() {
    if (pontos.any((ponto) => ponto.isEmpty)) {
      return '00:00';
    }
    Duration parseTime(String time) {
      final parts = time.split(':').map(int.parse).toList();
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
}
