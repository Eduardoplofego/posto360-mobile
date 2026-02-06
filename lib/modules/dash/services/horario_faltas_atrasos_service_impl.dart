import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';
import 'package:posto360/modules/dash/domain/repositories/horario_faltas_atrasos_repository.dart';

import '../infra/services/horario_faltas_atrasos_service.dart';

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
    final dataAtualFormatada = DataFormatters.formatarData(data);
    final result = await _horarioFaltasAtrasosRepository.getHorario(
      dataAtual: dataAtualFormatada,
      codigoFuncionario: codigoFuncionario,
    );
    return result;
  }
}
