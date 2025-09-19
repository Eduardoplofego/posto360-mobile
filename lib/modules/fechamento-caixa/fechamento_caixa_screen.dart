import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/select_date_widget.dart';
import 'package:posto360/modules/fechamento-caixa/domain/widgets/details_card_widget.dart';
import 'package:posto360/modules/fechamento-caixa/domain/widgets/resume_monthly_cards_widget.dart';
import 'package:posto360/modules/fechamento-caixa/fechamento_caixa_controller.dart';

class FechamentoCaixaScreen extends GetView<FechamentoCaixaController> {
  const FechamentoCaixaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Fechamento Caixa',
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
                    return ResumeMonthlyCardsWidget(
                      totalCartoesDeletados: controller.totalCartoesDeletados,
                      totalCartoesVinculados: controller.totalCartoesVinculados,
                      totalCartoesCorrigidos: controller.totalCartoesCorrigidos,
                      diferencaTotal: controller.diferencaTotal,
                      mesReferencia: controller.monthSelectedText,
                    );
                  }),
                  Obx(() {
                    return SelectDateWidget(
                      hideBackground: false,
                      nextMonthPressed: controller.selectNextMonth,
                      period: controller.monthSelected,
                      hasNextMonth: controller.hasNextMonth,
                      prevMonthPressed: controller.selectPreviusMonth,
                    );
                  }),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.loadingCards) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: PostoAppUiConfigurations.blueMediumColor,
                        ),
                      );
                    }
                    if (controller.cardList.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.point_of_sale, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text('Nenhum registro para esse mês'),
                        ],
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        itemCount: controller.cardList.length,
                        itemBuilder: (context, index) {
                          final card = controller.cardList[index];
                          return DetailsCardWidget(card: card);
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
