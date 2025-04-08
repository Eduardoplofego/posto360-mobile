import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/aula_model.dart';

abstract class AulasService {
  Future<ResultActionDTO<List<AulaModel>>> getAulas({
    required int cursoId,
    required String usuarioId,
  });
  Future<bool> concludeAula({required int aulaId});
}
