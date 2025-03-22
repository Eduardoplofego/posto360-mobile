import 'dart:convert';

class HorarioFaltasModel {
  final String horarioPrevisto;
  final int faltas;
  final int atrasos;

  HorarioFaltasModel({
    required this.horarioPrevisto,
    required this.faltas,
    required this.atrasos,
  });

  factory HorarioFaltasModel.empty() {
    return HorarioFaltasModel(
      horarioPrevisto: '00:00-00:00  00:00-00:00',
      faltas: 0,
      atrasos: 0,
    );
  }

  String getJornadaTrabalho() {
    if (horarioPrevisto.isEmpty) {
      return '00h às 00h';
    }

    final turnos = horarioPrevisto.split(' ');

    final primeiroTurnoSplitted = turnos[0].split('-');
    final segundoTurnosSplitted = turnos[2].split('-');

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
  }

  String getStartTime() {
    if (horarioPrevisto.isEmpty) {
      return '00h00';
    }

    final turnos = horarioPrevisto.split(' ');

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
      'faltas': faltas,
      'atrasos': atrasos,
    };
  }

  factory HorarioFaltasModel.fromMap(Map<String, dynamic> map) {
    return HorarioFaltasModel(
      horarioPrevisto: map['horarioPrevisto'] ?? '',
      faltas: map['faltas']?.toInt() ?? 0,
      atrasos: map['atrasos']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioFaltasModel.fromJson(String source) =>
      HorarioFaltasModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HorarioFaltas(horarioPrevisto: $horarioPrevisto, faltas: $faltas, atrasos: $atrasos)';
}
