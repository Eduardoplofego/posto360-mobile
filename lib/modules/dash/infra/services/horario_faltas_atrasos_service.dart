import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';

abstract class HorarioFaltasAtrasosService {
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required DateTime dataSelecionada,
    required DateTime dataAtual,
    required String codigoFuncionario,
  });
}
