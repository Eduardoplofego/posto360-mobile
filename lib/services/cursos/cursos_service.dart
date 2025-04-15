import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/curso_model.dart';

abstract class CursosService {
  Future<ResultActionDTO<List<CursoModel>>> getAllCursos({
    required String usuarioId,
  });
}
