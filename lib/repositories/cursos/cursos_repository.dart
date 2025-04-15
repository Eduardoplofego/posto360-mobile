import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/curso_model.dart';

abstract class CursosRepository {
  Future<ResultActionDTO<List<CursoModel>>> getCursos({
    required String usuarioId,
  });
}
