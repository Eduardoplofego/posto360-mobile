import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/horario_faltas_model.dart';

abstract class HorarioFaltasAtrasosRepository {
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required String data,
    required String codigoFuncionario,
  });
}
