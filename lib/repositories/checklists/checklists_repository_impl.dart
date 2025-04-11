import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/checklist_answer_model.dart';

import 'package:posto360/models/checklist_model.dart';

import './checklists_repository.dart';

class ChecklistsRepositoryImpl extends ChecklistsRepository {
  final PostoRestClient _postoRestClient;

  ChecklistsRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> checklistAnswer({
    required String usuarioId,
    required int checklistId,
  }) async {
    final result = await _postoRestClient.post(
      ApiRoutes.checklistAnswers(),
      {},
    );
    return ResultActionDTO.success(data: []);
  }

  @override
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlists({
    required String usuarioId,
    required int filialId,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.checklists(), {
        "usuarioId": usuarioId,
        "filialId": filialId,
      });
      final checklistMap = result.body['checklistsDisponiveis'];
      final checklists =
          checklistMap
              .map<ChecklistModel>((model) => ChecklistModel.fromMap(model))
              .toList() ??
          [];
      return ResultActionDTO.success(data: checklists);
    } catch (e, s) {
      log('Erro Get checklists', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar checklists', []);
    }
  }
}
