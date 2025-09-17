import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/domain/repositories/cursos_repository.dart';

import '../infra/services/cursos_service.dart';

class CursosServiceImpl extends CursosService {
  final CursosRepository _cursosRepository;

  CursosServiceImpl({required CursosRepository cursoRepository})
    : _cursosRepository = cursoRepository;

  @override
  Future<ResultActionDTO<List<CursoModel>>> getAllCursos({
    required String usuarioId,
  }) async => await _cursosRepository.getCursos(usuarioId: usuarioId);

  @override
  Future<ResultActionDTO<bool>> iniciarCurso({
    required String usuarioId,
    required int cursoId,
  }) async =>
      _cursosRepository.iniciarCurso(usuarioId: usuarioId, cursoId: cursoId);
}
