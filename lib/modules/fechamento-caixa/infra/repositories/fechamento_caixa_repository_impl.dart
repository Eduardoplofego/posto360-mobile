import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/cartoes_model.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/detalhes_cartoes_model.dart';
import '../../domain/repositories/app_fechamento_caixa_repository.dart';

class AppFechamentoCaixaRepositoryImpl extends AppFechamentoCaixaRepository {
  final PostoRestClient _restClient;

  AppFechamentoCaixaRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<CartoesModel>> getFechamento({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.fechamentoCaixa(), {
        "usuarioId": usuarioId,
        "dataInicial": dataInicial,
        "dataFinal": dataFinal,
      });

      if (result.statusCode == null || result.statusCode! > 300) {
        return ResultActionDTO.failure(
          'Erro ao buscar fechamento de caixa',
          CartoesModel.empty(),
        );
      }

      final body = result.body as Map<String, dynamic>?;

      if (body == null) {
        return ResultActionDTO.failure(
          'Erro ao buscar fechamento de caixa',
          CartoesModel.empty(),
        );
      }

      return ResultActionDTO.success(
        message: 'Sucesso ao buscar fechamento de caixa',
        data: CartoesModel.fromMap(body),
      );
    } catch (e, s) {
      log('Erro get horas_faltas_atraso', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar jornada de trabalho',
        CartoesModel.empty(),
      );
    }
  }

  @override
  Future<ResultActionDTO<List<DetalhesCartoesModel>>> getFechamentoDetalhes({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.fechamentoCaixaDetalhes(),
        {
          "usuarioId": usuarioId,
          "dataInicial": dataInicial,
          "dataFinal": dataFinal,
        },
      );

      if (result.statusCode == null || result.statusCode! > 300) {
        return ResultActionDTO.failure(
          'Erro ao buscar fechamento de caixa',
          [],
        );
      }

      final body = result.body as List;

      if (body.isEmpty) {
        return ResultActionDTO.success(
          message: 'Sucesso ao buscar fechamento de caixa',
          data: [],
        );
      }

      final listDetalhes =
          body
              .map<DetalhesCartoesModel>(
                (ele) => DetalhesCartoesModel.fromMap(ele),
              )
              .toList();

      return ResultActionDTO.success(
        message: 'Sucesso ao buscar fechamento de caixa',
        data: listDetalhes,
      );
    } catch (e, s) {
      log('Erro get horas_faltas_atraso', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar jornada de trabalho',
        [],
      );
    }
  }
}
