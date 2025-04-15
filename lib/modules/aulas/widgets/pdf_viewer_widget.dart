import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';

class PdfViewerWidget extends GetView<AulasController> {
  const PdfViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      color: PostoAppUiConfigurations.lightPurpleColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preparamos um material completo sobre liderança',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return Container(
                width: Get.width * .9,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('assets/images/icones/pdf_icone.png'),
                        Flexible(
                          child: Text(
                            controller.currentAula!.titulo,
                            style: TextStyle(
                              color: PostoAppUiConfigurations.textDarkColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.showMaterialAulaWidget();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(
                            color: PostoAppUiConfigurations.blueMediumColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Text(
                                'Visualizar PDF',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      PostoAppUiConfigurations.blueMediumColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward,
                                size: 24,
                                color: PostoAppUiConfigurations.blueMediumColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
