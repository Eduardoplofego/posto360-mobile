import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/enums/curso_status.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/dtos/curso_to_aula_dto.dart';

class CursoFolderWidget extends StatelessWidget {
  final CursoModel curso;
  final VoidCallback afterReturnClass;
  const CursoFolderWidget({
    super.key,
    required this.curso,
    required this.afterReturnClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 142,
      decoration: BoxDecoration(
        color: curso.capa == '' ? Colors.grey.shade200 : null,
        borderRadius: BorderRadius.circular(10),
        image:
            curso.capa != ''
                ? DecorationImage(
                  image: NetworkImage(curso.capa),
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
                if (curso.status != CursoStatus.finalizado) {
                  await Get.toNamed(
                    '/cursos/aulas',
                    arguments: CursoToAulaDTO(curso: curso),
                  );
                  afterReturnClass();
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
