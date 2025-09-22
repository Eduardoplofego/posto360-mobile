import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/aulas/domain/models/aula_model.dart';

abstract class AulaRepository {
  Future<ResultActionDTO<List<AulaModel>>> getAulas({
    required int cursoId,
    required String usuarioId,
  });
  Future<ResultActionDTO<bool>> concludeAula({required int aulaId});
}
