import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/registro_pontos/widgets/ponto_card_widget.dart';
import 'package:posto360/modules/registro_pontos/widgets/resume_card_widget.dart';
import 'registro_pontos_controller.dart';

class RegistroPontosPage extends GetView<RegistroPontosController> {
  const RegistroPontosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Registro de pontos',
          leading: BackIconButtonWidget(
            onPressed: () async {
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Obx(() {
                    return ResumeCardWidget(
                      model: controller.registroPontoModel,
                      mesReferencia: controller.monthSelectedText,
                    );
                  }),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.loadingData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: PostoAppUiConfigurations.blueLightColor,
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 6),
                        itemCount: controller.pontosList.length,
                        itemBuilder: (context, index) {
                          final item = controller.pontosList[index];
                          return PontoCardWidget(model: item);
                        },
                      ),
                    );
                  }),
                  // Obx(() {
                  //   return ResumeMonthlyCardsWidget(
                  //     totalCartoesDeletados: controller.totalCartoesDeletados,
                  //     totalCartoesVinculados: controller.totalCartoesVinculados,
                  //     totalCartoesCorrigidos: controller.totalCartoesCorrigidos,
                  //     diferencaTotal: controller.diferencaTotal,
                  //     mesReferencia: controller.monthSelectedText,
                  //   );
                  // }),
                  // const SizedBox(height: 16),
                  // Obx(() {
                  //   if (controller.loadingCards) {
                  //     return Center(
                  //       child: CircularProgressIndicator(
                  //         color: PostoAppUiConfigurations.blueMediumColor,
                  //       ),
                  //     );
                  //   }
                  //   if (controller.cardList.isEmpty) {
                  //     return Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.point_of_sale, color: Colors.grey),
                  //         const SizedBox(width: 6),
                  //         Text('Nenhum dado para apresentar'),
                  //       ],
                  //     );
                  //   }
                  //   return Expanded(
                  //     child: ListView.separated(
                  //       itemCount: controller.cardList.length,
                  //       itemBuilder: (context, index) {
                  //         final card = controller.cardList[index];
                  //         return DetailsCardWidget(card: card);
                  //       },
                  //       separatorBuilder:
                  //           (context, index) => const SizedBox(height: 12),
                  //     ),
                  //   );
                  // }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
