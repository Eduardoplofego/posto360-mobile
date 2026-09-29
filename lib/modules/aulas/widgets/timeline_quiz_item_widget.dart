import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

/// Espelha `TimelineClassItemWidget`, mas para o item de "Prova final" que
/// entra como último item da timeline de aulas quando o curso tem
/// questionário (design doc, seção 7.4).
class TimelineQuizItemWidget extends StatelessWidget {
  final bool bloqueada;
  final bool aprovado;

  const TimelineQuizItemWidget({
    super.key,
    required this.bloqueada,
    required this.aprovado,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * .85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 7,
                        spreadRadius: .2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        child:
                            bloqueada
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                              'Prova final',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PostoAppUiConfigurations.textDarkColor,
                              ),
                            ),
                            Text(
                              aprovado
                                  ? 'Aprovado'
                                  : bloqueada
                                  ? 'Termine as aulas para liberar'
                                  : 'Disponível',
                              style: TextStyle(
                                color: PostoAppUiConfigurations.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            ),
            child: CircleAvatar(
              backgroundColor:
                  !bloqueada ? Colors.blue.shade100 : Colors.grey.shade300,
              child: CircleAvatar(
                radius: 25,
                backgroundColor:
                    !bloqueada
                        ? PostoAppUiConfigurations.blueLightColor
                        : Colors.grey,
                child: Icon(
                  aprovado ? Icons.check : Icons.assignment,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
