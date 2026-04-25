import 'dart:convert';

class HorarioFaltasModel {
  final String? horarioPrevisto;
  final num faltasInjustificadas;
  final num faltasPonto;
  final num atrasosGrave;
  final num atrasosMedio;
  final num atrasosLeve;
  final num penalidade;

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

  List<String> _turnos() {
    final raw = horarioPrevisto;
    if (raw == null || raw.isEmpty) return const [];
    return raw.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
  }

  ({int hora, int minuto})? _parseHorario(String s) {
    final partes = s.split(':');
    if (partes.isEmpty) return null;
    final hora = int.tryParse(partes[0]) ?? 0;
    final minuto = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return (hora: hora, minuto: minuto);
  }

  String getJornadaTrabalho() {
    final turnos = _turnos();
    if (turnos.isEmpty) return '--';

    final primeiroTurno = turnos.first.split('-');
    final ultimoTurno = turnos.last.split('-');
    if (primeiroTurno.length < 2 || ultimoTurno.length < 2) return '--';

    final inicio = _parseHorario(primeiroTurno.first);
    final fim = _parseHorario(ultimoTurno.last);
    if (inicio == null || fim == null) return '--';

    final inicioStr =
        '${inicio.hora}h${inicio.minuto > 0 ? '${inicio.minuto}' : ''}';
    final fimStr = '${fim.hora}h${fim.minuto > 0 ? '${fim.minuto}' : ''}';
    return '$inicioStr às $fimStr';
  }

  String getStartTime() {
    final turnos = _turnos();
    if (turnos.isEmpty) return '';

    final primeiroTurno = turnos.first.split('-');
    if (primeiroTurno.isEmpty) return '';

    final inicio = _parseHorario(primeiroTurno.first);
    if (inicio == null) return '';

    final minutoStr = inicio.minuto.toString().padLeft(2, '0');
    return '${inicio.hora}h$minutoStr';
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
      faltasInjustificadas: (map['Falta injustificado'] as num?) ?? 0,
      faltasPonto: (map['Falta de ponto'] as num?) ?? 0,
      atrasosGrave: (map['Atraso grave'] as num?) ?? 0,
      atrasosMedio: (map['Atraso medio'] as num?) ?? 0,
      atrasosLeve: (map['Atraso leve'] as num?) ?? 0,
      penalidade: (map['Penalidade'] as num?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioFaltasModel.fromJson(String source) =>
      HorarioFaltasModel.fromMap(json.decode(source));
}
