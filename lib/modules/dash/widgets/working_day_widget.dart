import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class WorkingDayWidget extends StatelessWidget {
  const WorkingDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                    '8h às 18h',
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
                    '28 de Fevereiro, 09h20',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
