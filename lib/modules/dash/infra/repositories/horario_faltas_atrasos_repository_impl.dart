import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';

import '../../domain/repositories/horario_faltas_atrasos_repository.dart';

class HorarioFaltasAtrasosRepositoryImpl
    extends HorarioFaltasAtrasosRepository {
  final PostoRestClient _restClient;

  HorarioFaltasAtrasosRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required String dataInicial,
    required String dataFinal,
    required String dataAtual,
    required int codigoFuncionario,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.dashboardRH(), {
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
        'dataAtual': dataAtual,
        'funcionarioCodigo': codigoFuncionario,
      });
      return ResultActionDTO.success(
        data: HorarioFaltasModel.fromMap(result.body),
        message:
            result.body.containsKey('message') ? result.body['message'] : null,
      );
    } catch (e, s) {
      log('Erro get horas_faltas_atraso', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar jornada de trabalho',
        HorarioFaltasModel.empty(),
      );
    }
  }
}
