import 'package:posto360/core/dto/image_answer_dto.dart';
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
    required ImageAnswerDto imageAnswer,
  });
}
