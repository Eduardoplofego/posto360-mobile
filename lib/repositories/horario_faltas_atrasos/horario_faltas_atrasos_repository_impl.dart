import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/horario_faltas_model.dart';

import 'horario_faltas_atrasos_repository.dart';

class HorarioFaltasAtrasosRepositoryImpl
    extends HorarioFaltasAtrasosRepository {
  final PostoRestClient _restClient;

  HorarioFaltasAtrasosRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<HorarioFaltasModel>> getHorario({
    required String data,
    required String codigoFuncionario,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.honorario(), {
        'data': data,
        'funcionarioCodigo': codigoFuncionario,
      });
      return ResultActionDTO.success(
        data: HorarioFaltasModel.fromMap(result.body),
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
