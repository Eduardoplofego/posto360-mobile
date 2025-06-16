import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/enums/curso_status.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/dtos/curso_to_aula_dto.dart';

class CursoFolderWidget extends StatefulWidget {
  final CursoModel curso;
  final VoidCallback afterReturnClass;
  final Function(String) showMessageError;
  final Future<bool> Function({required int cursoId}) onStartCourse;
  const CursoFolderWidget({
    super.key,
    required this.curso,
    required this.afterReturnClass,
    required this.onStartCourse,
    required this.showMessageError,
  });

  @override
  State<CursoFolderWidget> createState() => _CursoFolderWidgetState();
}

class _CursoFolderWidgetState extends State<CursoFolderWidget> {
  Future<bool> _checkIfToStartCurso() async {
    final shouldStart = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Iniciar Curso'),
        content: Text(
          'Deseja iniciar esse curso?',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.red.shade400),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Iniciar',
              style: TextStyle(
                fontSize: 16,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldStart ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 142,
      decoration: BoxDecoration(
        color: widget.curso.capa == '' ? Colors.grey.shade200 : null,
        borderRadius: BorderRadius.circular(10),
        image:
            widget.curso.capa != ''
                ? DecorationImage(
                  image: NetworkImage(widget.curso.capa),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                bool isToCourse = true;
                if (widget.curso.status == CursoStatus.naoIniciado) {
                  final shouldStart = await _checkIfToStartCurso();

                  if (shouldStart) {
                    final resultStart = await widget.onStartCourse(
                      cursoId: widget.curso.id,
                    );

                    if (!resultStart) {
                      isToCourse = false;
                    }
                  }
                }

                if (isToCourse) {
                  await Get.toNamed(
                    '/cursos/aulas',
                    arguments: CursoToAulaDTO(curso: widget.curso),
                  );
                  widget.afterReturnClass();
                } else {
                  widget.showMessageError('Não foi possível iniciar o curso');
                }
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: PostoAppUiConfigurations.blueMediumColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
