import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/domain/repositories/procedimentos_repository.dart';

class ProcedimentosRepositoryImpl extends ProcedimentosRepository {
  final PostoRestClient _postoRestClient;

  ProcedimentosRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<ProcedimentoModel>>> getProcedimentos({
    required String userId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.procedimentos(),
        {'userId': userId},
      );
      final raw = result.body['procedimentos'] as List?;
      final procedimentos =
          raw
              ?.map<ProcedimentoModel>(
                (p) => ProcedimentoModel.fromMap(p as Map<String, dynamic>),
              )
              .toList() ??
          [];
      return ResultActionDTO.success(data: procedimentos);
    } catch (e, s) {
      log('Erro get procedimentos', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar procedimentos', []);
    }
  }

  @override
  Future<ResultActionDTO<List<ProcedimentoModel>>> getProcedimentosDetalhes({
    required String userId,
    required List<int> procedimentoIds,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.procedimentosDetalhes(),
        {'userId': userId, 'procedimentoIds': procedimentoIds},
      );
      final raw = result.body['procedimentos'] as List?;
      final procedimentos =
          raw
              ?.map<ProcedimentoModel>(
                (p) => ProcedimentoModel.fromMap(p as Map<String, dynamic>),
              )
              .toList() ??
          [];
      return ResultActionDTO.success(data: procedimentos);
    } catch (e, s) {
      log('Erro get procedimentos detalhes', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar detalhes do procedimento',
        [],
      );
    }
  }
}
