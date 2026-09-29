import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/questionario/domain/models/correcao_model.dart';
import 'package:posto360/modules/questionario/domain/models/questionario_model.dart';

abstract class QuestionarioService {
  Future<ResultActionDTO<QuestionarioModel>> getQuestionario({
    required String usuarioId,
    required int cursoId,
  });

  Future<ResultActionDTO<CorrecaoModel>> responderQuestionario({
    required String usuarioId,
    required int cursoId,
    required Map<int, int> respostas,
  });
}
