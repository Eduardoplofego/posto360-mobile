import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository.dart';

import './horario_faltas_atrasos_service.dart';

class HorarioFaltasAtrasosServiceImpl extends HorarioFaltasAtrasosService {
  final HorarioFaltasAtrasosRepository _horarioFaltasAtrasosRepository;

  HorarioFaltasAtrasosServiceImpl({
    required HorarioFaltasAtrasosRepository horarioFaltasAtrasosRepository,
  }) : _horarioFaltasAtrasosRepository = horarioFaltasAtrasosRepository;

  @override
  Future<HorarioFaltasModel> getHorario({
    required String data,
    required String codigoFuncionario,
  }) async => await _horarioFaltasAtrasosRepository.getHorario(
    data: data,
    codigoFuncionario: codigoFuncionario,
  );
}
