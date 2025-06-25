import 'package:posto360/core/dto/image_answer_dto.dart';
import 'package:posto360/core/dto/result_action_dto.dart';

import 'package:posto360/models/checklist_answer_model.dart';

import 'package:posto360/models/checklist_model.dart';
import 'package:posto360/repositories/checklists/checklists_repository.dart';

import './checklist_service.dart';

class ChecklistServiceImpl extends ChecklistService {
  final ChecklistsRepository _checklistsRepository;

  ChecklistServiceImpl({required ChecklistsRepository checklistRepository})
    : _checklistsRepository = checklistRepository;

  @override
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> checklistAnswer({
    required String usuarioId,
    required int checklistId,
  }) async => await _checklistsRepository.getChecklistAnswers(
    usuarioId: usuarioId,
    checklistId: checklistId,
  );

  @override
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlists({
    required String usuarioId,
    required int filialId,
  }) async {
    final resultChecklistAvailables = await _checklistsRepository.getChechlists(
      usuarioId: usuarioId,
      filialId: filialId,
    );

    final resultChecklistConcluded = await _checklistsRepository
        .getChechlistsConcluded(usuarioId: usuarioId, filialId: filialId);

    if (resultChecklistAvailables.success && resultChecklistConcluded.success) {
      final checklists = <ChecklistModel>[];
      checklists.addAll(resultChecklistConcluded.data!.toList());
      checklists.addAll(resultChecklistAvailables.data!.toList());
      return ResultActionDTO.success(data: checklists);
    }

    return ResultActionDTO.failure(
      'Não foi possivel carregar as checklists',
      [],
    );
  }

  @override
  Future<ResultActionDTO<bool>> startChecklist({
    required String usuarioId,
    required int checklistId,
  }) async => await _checklistsRepository.startChecklist(
    usuarioId: usuarioId,
    checklistId: checklistId,
  );

  @override
  Future<ResultActionDTO<bool>> pushChecklistAnswer<T>({
    required int respostaId,
    required T resposta,
    String? observacoes,
    String? photoUrl,
    bool? necessitaRevisao,
  }) async => await _checklistsRepository.pushChecklistAnswer(
    respostaId: respostaId,
    resposta: resposta,
    observacoes: observacoes,
    photoUrl: photoUrl,
    necessitaRevisao: necessitaRevisao,
  );

  @override
  Future<ResultActionDTO<String>> subirImagem({
    required int respostaId,
    required ImageAnswerDto imageAnswer,
  }) async => await _checklistsRepository.subirImagem(
    respostaId: respostaId,
    imageAnswer: imageAnswer.toJson(),
  );

  @override
  Future<ResultActionDTO<bool>> finalizarChecklist({
    required int checklistId,
  }) async =>
      await _checklistsRepository.finalizarChecklist(checklistid: checklistId);
}
