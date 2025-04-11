import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/checklist_answer_model.dart';
import 'package:posto360/models/checklist_model.dart';

abstract class ChecklistService {
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlists({
    required String usuarioId,
    required int filialId,
  });
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> checklistAnswer({
    required String usuarioId,
    required int checklistId,
  });
}
