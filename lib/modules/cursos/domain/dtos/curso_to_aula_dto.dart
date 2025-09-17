import 'package:posto360/modules/aulas/domain/models/curso_model.dart';

class CursoToAulaDTO {
  final CursoModel curso;

  CursoToAulaDTO({required this.curso});

  @override
  String toString() => 'CursoToAulaDTO(curso: $curso)';
}
