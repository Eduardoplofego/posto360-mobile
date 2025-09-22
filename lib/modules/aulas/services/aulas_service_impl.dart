import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

import 'package:posto360/modules/aulas/domain/models/aula_model.dart';
import 'package:posto360/modules/aulas/domain/repositories/aula_repository.dart';

import '../infra/services/aulas_service.dart';

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

  @override
  Future<bool> concludeAula({required int aulaId}) async {
    final result = await _aulasRepository.concludeAula(aulaId: aulaId);
    if (result.isError) {
      return false;
    }
    return true;
  }
}
