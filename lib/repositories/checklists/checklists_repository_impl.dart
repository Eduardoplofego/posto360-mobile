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
    try {
      final result = await _postoRestClient.post(ApiRoutes.checklistAnswers(), {
        "usuarioId": usuarioId,
        "checklistId": checklistId,
      });
      final answersMap = result.body;
      final answers =
          answersMap
              .map<ChecklistAnswerModel>(
                (answer) => ChecklistAnswerModel.fromMap(answer),
              )
              .toList() ??
          [];
      return ResultActionDTO.success(data: answers);
    } catch (e, s) {
      log('Erro get checklist answers', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar respostas', []);
    }
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
