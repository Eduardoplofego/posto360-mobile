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
    required int funcionarioCodigo,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.dashboardRH(), {
        'funcionarioCodigo': funcionarioCodigo,
        'dataAtual': dataAtual,
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
      });
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get horas_faltas_atraso [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao carregar jornada de trabalho',
          HorarioFaltasModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic>) {
        log(
          'Resposta inesperada dashboard/rh',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          HorarioFaltasModel.empty(),
        );
      }
      log('dashboard/rh response: ${result.bodyString}');
      return ResultActionDTO.success(
        data: HorarioFaltasModel.fromMap(body),
        message: body.containsKey('message') ? body['message'] : null,
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
