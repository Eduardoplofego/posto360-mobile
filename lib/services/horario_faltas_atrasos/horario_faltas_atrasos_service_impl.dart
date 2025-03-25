import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository.dart';

import './horario_faltas_atrasos_service.dart';

class HorarioFaltasAtrasosServiceImpl extends HorarioFaltasAtrasosService {
  final HorarioFaltasAtrasosRepository _horarioFaltasAtrasosRepository;

  HorarioFaltasAtrasosServiceImpl({
    required HorarioFaltasAtrasosRepository horarioFaltasAtrasosRepository,
  }) : _horarioFaltasAtrasosRepository = horarioFaltasAtrasosRepository;

  @override
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required DateTime data,
    required String codigoFuncionario,
  }) async {
    final monthString = data.month < 10 ? '0${data.month}' : '${data.month}';
    final dayString = data.day < 10 ? '0${data.day}' : '${data.day}';
    final result = await _horarioFaltasAtrasosRepository.getHorario(
      data: '${data.year}-$monthString-$dayString',
      codigoFuncionario: codigoFuncionario,
    );
    return result;
  }
}
