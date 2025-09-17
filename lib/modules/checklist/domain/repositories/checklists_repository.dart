import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_answer_model.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_model.dart';

abstract class ChecklistsRepository {
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlists({
    required String usuarioId,
    required int filialId,
  });
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlistsConcluded({
    required String usuarioId,
    required int filialId,
  });
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> getChecklistAnswers({
    required String usuarioId,
    required int checklistId,
  });
  Future<ResultActionDTO<bool>> startChecklist({
    required String usuarioId,
    required int checklistId,
  });
  Future<ResultActionDTO<bool>> pushChecklistAnswer<T>({
    required int respostaId,
    required T resposta,
    String? observacoes,
    String? photoUrl,
    bool? necessitaRevisao,
  });
  Future<ResultActionDTO<String>> subirImagem({
    required int respostaId,
    required Map<String, dynamic> imageAnswer,
  });
  Future<ResultActionDTO<bool>> finalizarChecklist({required int checklistid});
}
