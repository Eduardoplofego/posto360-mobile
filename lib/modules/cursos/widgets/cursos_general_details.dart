import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/cursos/cursos_controller.dart';
import 'package:posto360/modules/cursos/widgets/curso_dashboard_item.dart';

class CursosGeneralDetails extends GetView<CursosController> {
  const CursosGeneralDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() {
        return Wrap(
          runAlignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: (Get.width - 32) * .44,
              child: CursoDashboardItem(
                image: 'assets/images/icones/graduacao.png',
                text: 'Cursos',
                value: controller.totalCursos.toString(),
              ),
            ),
            SizedBox(
              width: (Get.width - 32) * .44,
              child: CursoDashboardItem(
                image: 'assets/images/icones/trofeu.png',
                text: 'Finalizados',
                value: controller.cursosFinalizados.toString(),
              ),
            ),
            SizedBox(
              width: (Get.width - 32) * .44,
              child: CursoDashboardItem(
                image: 'assets/images/icones/flag.png',
                text: 'Aulas',
                value:
                    '${controller.aulasFinalizadas}/${controller.totalAulas}',
              ),
            ),
            SizedBox(
              width: (Get.width - 32) * .44,
              child: CursoDashboardItem(
                image: 'assets/images/icones/certificado.png',
                text: 'Certificados',
                value:
                    '${controller.certificadosEmitidos}/${controller.totalCertificados}',
              ),
            ),
          ],
        );
      }),
    );
  }
}
