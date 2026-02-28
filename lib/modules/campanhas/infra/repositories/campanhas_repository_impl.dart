import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';

import '../../domain/repositories/app_campanhas_repository.dart';

class CampanhasRepositoryImpl extends AppCampanhasRepository {
  final PostoRestClient _restClient;

  CampanhasRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String usuarioId,
    required int empresaId,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.campanhas(), {
        "dataInicial": dataInicial,
        "dataFinal": dataFinal,
        "filialId": filialId,
        "usuarioId": usuarioId,
        "empresaId": empresaId,
      });
      final campanhas =
          result.body
              .map<CampanhaModel>((model) => CampanhaModel.fromMap(model))
              .toList() ??
          [];
      return ResultActionDTO.success(data: campanhas);
    } catch (e, s) {
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', []);
    }
  }
}
