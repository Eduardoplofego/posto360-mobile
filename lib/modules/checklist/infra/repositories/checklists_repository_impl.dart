import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_answer_model.dart';

import 'package:posto360/modules/checklist/domain/models/checklist_model.dart';

import '../../domain/repositories/checklists_repository.dart';

class ChecklistsRepositoryImpl extends ChecklistsRepository {
  final PostoRestClient _postoRestClient;

  ChecklistsRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> getChecklistAnswers({
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

  @override
  Future<ResultActionDTO<bool>> startChecklist({
    required String usuarioId,
    required int checklistId,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.iniciarChecklist(), {
        'usuarioId': usuarioId,
        'checklistId': checklistId,
      });

      final resultMessage = result.body['message'] as String?;

      if (resultMessage != null &&
          (resultMessage.contains('Checklist encontra-se Em Andamento') ||
              resultMessage.contains('Checklist foi iniciado'))) {
        return ResultActionDTO.success();
      } else {
        return ResultActionDTO.failure(
          'Não foi possível iniciar esta checklist. Tente novamente.',
          false,
        );
      }
    } catch (e, s) {
      log('Error start checklist', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Não foi possível iniciar esta checklist. Tente novamente.',
        false,
      );
    }
  }

  @override
  Future<ResultActionDTO<bool>> pushChecklistAnswer<T>({
    required int respostaId,
    required T resposta,
    String? observacoes,
    String? photoUrl,
    bool? necessitaRevisao,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.subirResposta(), {
        'respostaId': respostaId,
        'resposta': resposta,
        'observacoes': observacoes,
        'fotoUrl': photoUrl,
        'necessitaRevisao': necessitaRevisao,
      });

      final resultMessage = result.body['message'] as String?;

      if (resultMessage != null &&
          resultMessage.contains("Resposta dada com sucesso!")) {
        return ResultActionDTO.success();
      } else {
        return ResultActionDTO.failure(
          'Não foi possível enviar essa resposta',
          false,
        );
      }
    } catch (e, s) {
      log('Erro subir resposta', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Não foi possível enviar essa resposta',
        false,
      );
    }
  }

  @override
  Future<ResultActionDTO<String>> subirImagem({
    required int respostaId,
    required Map<String, dynamic> imageAnswer,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.subirImagem(), {
        'respostaId': respostaId,
        'imagem': imageAnswer,
      });

      if (result.statusCode != null && result.statusCode! > 400) {
        return ResultActionDTO.failure('Não foi possível salvar a imagem', '');
      }

      final resultUrl = result.body['url'] as String?;

      if (resultUrl != null) {
        return ResultActionDTO.success(data: resultUrl);
      } else {
        return ResultActionDTO.failure('Não foi possível salvar a imagem', '');
      }
    } catch (e, s) {
      log('Erro subir imagem', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível salvar a imagem', '');
    }
  }

  @override
  Future<ResultActionDTO<bool>> finalizarChecklist({
    required int checklistid,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.finalizarChecklist(),
        {'checklistId': checklistid},
      );
      final resultMessage = result.body['message'] as String?;

      if (resultMessage != null &&
          resultMessage.contains('Checklist finalizado com sucesso')) {
        return ResultActionDTO.success(data: true);
      }

      return ResultActionDTO.failure(
        'Não foi possível finalizar a checklist',
        false,
      );
    } catch (e, s) {
      log('Erro finalizar checklist', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Não foi possível finalizar a checklist',
        false,
      );
    }
  }

  @override
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlistsConcluded({
    required String usuarioId,
    required int filialId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.checklistsFinalizadas(),
        {"usuarioId": usuarioId, "filialId": filialId},
      );
      final checklistMap = result.body['checklistsDisponiveis'];
      final checklists =
          checklistMap
              .map<ChecklistModel>((model) => ChecklistModel.fromMap(model))
              .toList() ??
          [];
      return ResultActionDTO.success(data: checklists);
    } catch (e, s) {
      log('Erro Get checklists finalizadas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar checklists', []);
    }
  }
}
