import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/dash/domain/models/campanha_model.dart';

import '../../domain/repositories/campanhas_repository.dart';

class CampanhasRepositoryImpl extends CampanhasRepository {
  final PostoRestClient _restClient;

  CampanhasRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<CampanhaModel>> getCampanha({
    required int campanhaId,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.dashboardCampanhas(), {
        'campanhaId': campanhaId,
      });
      final campanha = CampanhaModel.fromMap(
        result.body as Map<String, dynamic>,
      );
      return ResultActionDTO.success(data: campanha);
    } catch (e, s) {
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', null);
    }
  }
}
