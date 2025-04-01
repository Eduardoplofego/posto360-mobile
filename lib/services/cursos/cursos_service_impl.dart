import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/repositories/cursos/cursos_repository.dart';

import './cursos_service.dart';

class CursosServiceImpl extends CursosService {
  final CursosRepository _cursosRepository;

  CursosServiceImpl({required CursosRepository cursoRepository})
    : _cursosRepository = cursoRepository;

  @override
  Future<ResultActionDTO<List<CursoModel>>> getAllCursos({
    required String usuarioId,
  }) async => await _cursosRepository.getCursos(usuarioId: usuarioId);
}
