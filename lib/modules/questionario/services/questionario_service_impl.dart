import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/questionario/domain/models/correcao_model.dart';
import 'package:posto360/modules/questionario/domain/models/questionario_model.dart';
import 'package:posto360/modules/questionario/domain/repositories/questionario_repository.dart';

import '../infra/services/questionario_service.dart';

class QuestionarioServiceImpl extends QuestionarioService {
  final QuestionarioRepository _questionarioRepository;

  QuestionarioServiceImpl({
    required QuestionarioRepository questionarioRepository,
  }) : _questionarioRepository = questionarioRepository;

  @override
  Future<ResultActionDTO<QuestionarioModel>> getQuestionario({
    required String usuarioId,
    required int cursoId,
  }) async => await _questionarioRepository.getQuestionario(
    usuarioId: usuarioId,
    cursoId: cursoId,
  );

  @override
  Future<ResultActionDTO<CorrecaoModel>> responderQuestionario({
    required String usuarioId,
    required int cursoId,
    required Map<int, int> respostas,
  }) async => await _questionarioRepository.responderQuestionario(
    usuarioId: usuarioId,
    cursoId: cursoId,
    respostas: respostas,
  );
}
