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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: PostoAppUiConfigurations.blueMediumColor,
                        size: 40,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Jornada de Trabalho',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            ),
                            Obx(() {
                              return Text(
                                controller.horarioFaltasAtrasos
                                    .getJornadaTrabalho(),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      PostoAppUiConfigurations.blueMediumColor,
                                  fontSize: 19,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                height: 50, // Defina uma altura adequada
                child: VerticalDivider(width: 4, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoje:',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            Obx(() {
                              return Text(
                                '${formatDate(today)}, ${controller.horarioFaltasAtrasos.getStartTime() != '' ? controller.horarioFaltasAtrasos.getStartTime() : '00h00'}',
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
