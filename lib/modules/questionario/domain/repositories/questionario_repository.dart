import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/questionario/domain/models/correcao_model.dart';
import 'package:posto360/modules/questionario/domain/models/questionario_model.dart';

abstract class QuestionarioRepository {
  Future<ResultActionDTO<QuestionarioModel>> getQuestionario({
    required String usuarioId,
    required int cursoId,
  });

  /// [respostas] é um mapa questaoId -> alternativaId, com apenas as
  /// questões desta rodada (o servidor ignora resposta de questão bloqueada)
  Future<ResultActionDTO<CorrecaoModel>> responderQuestionario({
    required String usuarioId,
    required int cursoId,
    required Map<int, int> respostas,
  });
}
