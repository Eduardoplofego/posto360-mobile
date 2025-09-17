import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/cursos/cursos_controller.dart';
import 'package:posto360/modules/cursos/widgets/curso_card.dart';

class CursosTabItem extends GetView<CursosController> {
  const CursosTabItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cursosToShow.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              'Nenhum curso listado',
              style: TextStyle(color: PostoAppUiConfigurations.greyColor),
            ),
          ),
        );
      }
      return SizedBox(
        height: 380 * (controller.cursosToShow.length).toDouble(),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemCount: controller.cursosToShow.length,
          itemBuilder: (context, index) {
            final curso = controller.cursosToShow[index];
            return CursoCard(
              curso: curso,
              afterReturnClass: controller.loadCursos,
              onStartCourse: controller.startCurso,
              showMessageError: controller.showMessageError,
            );
          },
        ),
      );
    });
  }
}
