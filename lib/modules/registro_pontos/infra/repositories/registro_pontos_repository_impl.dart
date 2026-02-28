import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/registro_pontos/domain/helpers/pontos_model_helper.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import '../../domain/repositories/registro_pontos_repository.dart';

class RegistroPontosRepositoryImpl extends RegistroPontosRepository {
  final PostoRestClient _client;

  RegistroPontosRepositoryImpl(this._client);

  @override
  Future<ResultActionDTO<List<PontosModel>>> getAllRegisters({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final response = await _client.post(ApiRoutes.registroPontosDetalhes(), {
        "usuarioId": usuarioId,
        "dataInicial": dataInicial,
        "dataFinal": dataFinal,
      });

      if (response.statusCode == null || response.statusCode! > 300) {
        return ResultActionDTO.failure(
          'Erro ao buscar registro de pontos',
          null,
        );
      }

      final body =
          (response.body as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList();

      final pontos = body.map((ele) => getFromMap(ele)).toList();
      return ResultActionDTO.success(data: pontos);
    } catch (e, s) {
      log('Erro get registro pontos', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar registro de pontos',
        null,
      );
    }
  }

  @override
  Future<ResultActionDTO<FaltasAtrasosModel>> getFaltasAtrasos({
    required String dataInicial,
    required String dataFinal,
    required String dataAtual,
    required int codigoFuncionario,
  }) async {
    try {
      final result = await _client.post(ApiRoutes.dashboardRH(), {
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
        'dataAtual': dataAtual,
        'funcionarioCodigo': codigoFuncionario,
      });
      return ResultActionDTO.success(
        data: FaltasAtrasosModel.fromMap(result.body),
        message:
            result.body.containsKey('message') ? result.body['message'] : null,
      );
    } catch (e, s) {
      log('Erro get horas_faltas_atraso', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar jornada de trabalho',
        null,
      );
    }
  }
}
