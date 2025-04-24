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
  }) async => await _checklistsRepository.getChechlists(
    usuarioId: usuarioId,
    filialId: filialId,
  );

  @override
  Future<ResultActionDTO<bool>> startChecklist({
    required String usuarioId,
    required int checklistId,
  }) async => _checklistsRepository.startChecklist(
    usuarioId: usuarioId,
    checklistId: checklistId,
  );
}
