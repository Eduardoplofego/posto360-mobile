import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/enums/aula_status.dart';
import 'package:posto360/models/aula_model.dart';

class TimelineClassItemWidget extends StatelessWidget {
  final AulaModel aula;
  const TimelineClassItemWidget({super.key, required this.aula});

  @override
  Widget build(BuildContext context) {
    final isConcluded = aula.status == AulaStatus.finalizado;
    final isBlocked = aula.status == AulaStatus.bloqueado;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * .85,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        child:
                            isBlocked
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.lock,
                                        size: 26,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                )
                                : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aula ${aula.ordem}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PostoAppUiConfigurations.greyColor,
                              ),
                            ),
                            Text(
                              aula.titulo,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PostoAppUiConfigurations.textDarkColor,
                              ),
                            ),
                            Text('Duração: -'),
                          ],
                        ),
                      ),
                      Divider(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Image.asset(
                              isConcluded
                                  ? 'assets/images/icones/selo_amarelo.png'
                                  : 'assets/images/icones/selo_branco.png',
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 6,
                                children: [
                                  Text(
                                    isConcluded
                                        ? '100% completo'
                                        : '0% completo',
                                    style: TextStyle(
                                      color:
                                          !isBlocked
                                              ? PostoAppUiConfigurations
                                                  .blueMediumColor
                                              : PostoAppUiConfigurations
                                                  .greyColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  LinearProgressIndicator(
                                    value: isConcluded ? .8 : 0,
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor:
                                        PostoAppUiConfigurations
                                            .lightPurpleColor,
                                    color:
                                        PostoAppUiConfigurations
                                            .blueMediumColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 70,
            height: 70,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            ),
            child: CircleAvatar(
              backgroundColor:
                  !isBlocked ? Colors.blue.shade100 : Colors.grey.shade300,
              child: CircleAvatar(
                radius: 25,
                backgroundColor:
                    !isBlocked
                        ? PostoAppUiConfigurations.blueLightColor
                        : Colors.grey,
                child:
                    isConcluded
                        ? Icon(Icons.check, color: Colors.white, size: 28)
                        : Text(
                          '${aula.ordem}',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
