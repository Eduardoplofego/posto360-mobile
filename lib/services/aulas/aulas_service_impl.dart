import 'package:posto360/core/dto/result_action_dto.dart';

import 'package:posto360/models/aula_model.dart';
import 'package:posto360/repositories/aulas/aula_repository.dart';

import './aulas_service.dart';

class AulasServiceImpl extends AulasService {
  final AulaRepository _aulasRepository;

  AulasServiceImpl({required AulaRepository aulaRepository})
    : _aulasRepository = aulaRepository;

  @override
  Future<ResultActionDTO<List<AulaModel>>> getAulas({
    required int cursoId,
    required String usuarioId,
  }) async =>
      await _aulasRepository.getAulas(cursoId: cursoId, usuarioId: usuarioId);
}
