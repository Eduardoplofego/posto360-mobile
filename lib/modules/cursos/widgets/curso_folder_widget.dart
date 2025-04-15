import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/dtos/curso_to_aula_dto.dart';

class CursoFolderWidget extends StatelessWidget {
  final CursoModel curso;
  const CursoFolderWidget({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 142,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(curso.capa),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(
                  '/cursos/aulas',
                  arguments: CursoToAulaDTO(curso: curso),
                );
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
