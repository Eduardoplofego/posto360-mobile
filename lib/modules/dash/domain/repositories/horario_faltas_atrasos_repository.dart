import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';

abstract class HorarioFaltasAtrasosRepository {
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required String dataAtual,
    required String dataMes,
    required String codigoFuncionario,
  });
}
