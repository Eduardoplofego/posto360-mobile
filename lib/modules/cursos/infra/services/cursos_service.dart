import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';

abstract class CursosService {
  Future<ResultActionDTO<List<CursoModel>>> getAllCursos({
    required String usuarioId,
  });
  Future<ResultActionDTO<bool>> iniciarCurso({
    required String usuarioId,
    required int cursoId,
  });
}
