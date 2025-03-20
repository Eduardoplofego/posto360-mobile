import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/dash_controller.dart';

class WorkingDayWidget extends GetView<DashController> {
  const WorkingDayWidget({super.key});

  String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat("d 'de' MMMM", 'pt_BR');

    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Obx(() {
      return Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightPurpleColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: PostoAppUiConfigurations.blueMediumColor,
                  size: Get.width * .1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Jornada de Trabalho',
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      controller.horarioFaltasAtrasos.getJornadaTrabalho(),
                      style: TextStyle(
                        fontSize: 20,
                        color: PostoAppUiConfigurations.blueMediumColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: VerticalDivider(color: Colors.white),
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hoje:'),
                    Text(
                      '${formatDate(today)}, 09h20',
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
