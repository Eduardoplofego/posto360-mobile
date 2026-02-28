class PontosModel {
  final DateTime data;
  final List<String> pontos;

  PontosModel({required this.data, required this.pontos});

  String getTotalWorkHours() {
    Duration parseTime(String time) {
      final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);
      if (match == null) return Duration.zero;

      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);

      return Duration(hours: hour, minutes: minute);
    }

    final entrada1 =
        pontos[0].isNotEmpty ? parseTime(pontos[0]) : Duration.zero;
    final saida1 = pontos[1].isNotEmpty ? parseTime(pontos[1]) : Duration.zero;
    final entrada2 =
        pontos[2].isNotEmpty ? parseTime(pontos[2]) : Duration.zero;
    final saida2 = pontos[3].isNotEmpty ? parseTime(pontos[3]) : Duration.zero;

    final total = (saida1 - entrada1) + (saida2 - entrada2);

    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);

    final totalHour =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    final regex = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

    final isInFormat = regex.hasMatch(totalHour);

    return isInFormat ? totalHour : '-';
    // Duration parseTime(String? time) {
    //   if (time == null) return Duration.zero;

    //   final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);
    //   if (match == null) return Duration.zero;

    //   final hour = int.parse(match.group(1)!);
    //   final minute = int.parse(match.group(2)!);

    //   return Duration(hours: hour, minutes: minute);
    // }

    // final entrada1 = parseTime(pontos[0]);
    // final saida1 = parseTime(pontos[1]);
    // final entrada2 = parseTime(pontos[2]);
    // final saida2 = parseTime(pontos[3]);

    // final total = (saida1 - entrada1) + (saida2 - entrada2);

    // final hours = total.inHours;
    // final minutes = total.inMinutes.remainder(60);

    // return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    // return "8h";
  }

  Map<String, dynamic> toMap() {
    return {'data': data, 'pontos': pontos};
  }
}
