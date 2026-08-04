import 'package:posto360/modules/registro_pontos/domain/models/batida_model.dart';

class PontosModel {
  final DateTime data;
  final List<BatidaModel> pontos;

  PontosModel({required this.data, required this.pontos});

  /// Batidas do dia que possuem algum marcador vindo da API (ex.: `(I)`).
  List<BatidaModel> get batidasComMarcador =>
      pontos.where((ponto) => ponto.hasMarcador).toList();

  bool get hasBatidaComMarcador => batidasComMarcador.isNotEmpty;

  String getTotalWorkHours() {
    Duration parseTime(String time) {
      final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);
      if (match == null) return Duration.zero;

      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);

      return Duration(hours: hour, minutes: minute);
    }

    final entrada1 =
        pontos[0].hora.isNotEmpty ? parseTime(pontos[0].hora) : Duration.zero;
    final saida1 =
        pontos[1].hora.isNotEmpty ? parseTime(pontos[1].hora) : Duration.zero;
    final entrada2 =
        pontos[2].hora.isNotEmpty ? parseTime(pontos[2].hora) : Duration.zero;
    final saida2 =
        pontos[3].hora.isNotEmpty ? parseTime(pontos[3].hora) : Duration.zero;

    final total = (saida1 - entrada1) + (saida2 - entrada2);

    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);

    final totalHour =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    final regex = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

    final isInFormat = regex.hasMatch(totalHour);

    return isInFormat ? totalHour : '-';
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'pontos': pontos.map((ponto) => ponto.toMap()).toList(),
    };
  }
}
