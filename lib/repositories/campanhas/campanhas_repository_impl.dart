import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/campanha_model.dart';

import './campanhas_repository.dart';

class CampanhasRepositoryImpl extends CampanhasRepository {
  final PostoRestClient _restClient;

  CampanhasRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String tipoUsuario,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.campanhas(), {
        'filialId': filialId,
        'tipoUsuario': tipoUsuario,
      });
      final campanhas =
          result.body
                  .map<CampanhaModel>((model) => CampanhaModel.fromMap(model))
                  .toList()
              as List<CampanhaModel>;
      return ResultActionDTO.success(data: campanhas);
    } catch (e, s) {
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', []);
    }
  }
}
