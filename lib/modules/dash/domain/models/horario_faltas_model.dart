import 'dart:convert';

class HorarioFaltasModel {
  final String? horarioPrevisto;
  final double faltasInjustificadas;
  final double faltasPonto;
  final double atrasosGrave;
  final double atrasosMedio;
  final double atrasosLeve;
  final double penalidade;

  HorarioFaltasModel({
    required this.horarioPrevisto,
    required this.faltasInjustificadas,
    required this.faltasPonto,
    required this.atrasosGrave,
    required this.atrasosMedio,
    required this.atrasosLeve,
    required this.penalidade,
  });

  factory HorarioFaltasModel.empty() {
    return HorarioFaltasModel(
      horarioPrevisto: '',
      faltasInjustificadas: 0,
      faltasPonto: 0,
      atrasosGrave: 0,
      atrasosMedio: 0,
      atrasosLeve: 0,
      penalidade: 0,
    );
  }

  String getJornadaTrabalho() {
    try {
      if (horarioPrevisto == null || horarioPrevisto!.isEmpty) {
        return '--';
      }

      final turnos = horarioPrevisto!.split(' ');

      if (turnos.length == 1) return getMidPeriod(turnos[0]);

      final primeiroTurnoSplitted = turnos[0].split('-');
      final segundoTurnosSplitted = turnos[1].split('-');

      final tempoInicio = primeiroTurnoSplitted[0];
      final tempoFim = segundoTurnosSplitted[1];

      final horaTempoInicio = int.tryParse(tempoInicio.split(':')[0]) ?? 0;
      final minutoTempoInicio = int.tryParse(tempoInicio.split(':')[1]) ?? 0;
      final horaTempoFim = int.tryParse(tempoFim.split(':')[0]) ?? 0;
      final minutoTempoFim = int.tryParse(tempoFim.split(':')[1]) ?? 0;

      final inicio =
          '${horaTempoInicio}h${minutoTempoInicio > 0 ? '$minutoTempoInicio' : ''}';
      final fim =
          '${horaTempoFim}h${minutoTempoFim > 0 ? '$minutoTempoFim' : ''}';
      return '$inicio às $fim';
    } catch (_) {
      return "--";
    }
  }

  String getMidPeriod(String period) {
    final firstTime = period.split('-')[0];
    final secondTime = period.split('-')[1];

    final firstHour = firstTime.split(':')[0];
    final lastHour = secondTime.split(':')[0];

    return '${firstHour}h às ${lastHour}h';
  }

  String getStartTime() {
    if (horarioPrevisto == null || horarioPrevisto!.isEmpty) {
      return '';
    }

    final turnos = horarioPrevisto!.split(' ');

    final primeiroTurnoSplitted = turnos[0].split('-');

    final tempoInicio = primeiroTurnoSplitted[0];

    final horaTempoInicio = tempoInicio.split(':')[0];
    final minutoTempoInicio = tempoInicio.split(':')[1];

    final inicio = '${horaTempoInicio}h$minutoTempoInicio';
    return inicio;
  }

  Map<String, dynamic> toMap() {
    return {
      'horarioPrevisto': horarioPrevisto,
      'faltasInjustificadas': faltasInjustificadas,
      'faltasPonto': faltasPonto,
      'atrasosGrave': atrasosGrave,
      'atrasosMedio': atrasosMedio,
      'atrasosLeve': atrasosLeve,
      'penalidade': penalidade,
    };
  }

  factory HorarioFaltasModel.fromMap(Map<String, dynamic> map) {
    return HorarioFaltasModel(
      horarioPrevisto: map['horarioPrevisto'] ?? '',
      faltasInjustificadas:
          (map['Falta injustificado'] as num?)?.toDouble() ?? 0,
      faltasPonto: (map['Falta de ponto'] as num?)?.toDouble() ?? 0,
      atrasosGrave: (map['Atraso grave'] as num?)?.toDouble() ?? 0,
      atrasosMedio: (map['Atraso medio'] as num?)?.toDouble() ?? 0,
      atrasosLeve: (map['Atraso leve'] as num?)?.toDouble() ?? 0,
      penalidade: (map['Penalidade'] as num?)?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioFaltasModel.fromJson(String source) =>
      HorarioFaltasModel.fromMap(json.decode(source));
}
