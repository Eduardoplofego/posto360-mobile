import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/select_date_widget.dart';
import 'package:posto360/modules/campanhas/widgets/campanha_card_widget.dart';
import 'package:posto360/modules/campanhas/widgets/card_total_bonus_widget.dart';
import './campanhas_controller.dart';

class CampanhasPage extends GetView<CampanhasController> {
  const CampanhasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Produtos Incentivados',
          leading: BackIconButtonWidget(
            onPressed: () async {
              Get.back(closeOverlays: true);
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
              child: Obx(() {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    CardLoadingWidget(
                      isLoading: controller.isLoading,
                      height: 120,
                      initDelay: 50,
                      child: CardTotalBonusWidget(),
                    ),
                    SelectDateWidget(
                      nextMonthPressed: controller.nextMonth,
                      period: controller.monthSelected,
                      hasNextMonth: controller.hasNextMonth,
                      prevMonthPressed: controller.prevMonth,
                    ),
                    if (!controller.isLoading && controller.campanhas.isEmpty)
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: Text('Nenhuma campanha encontrada nesse mês'),
                        ),
                      ),
                    if (!controller.isLoading &&
                        controller.campanhas.isNotEmpty)
                      SizedBox(
                        height: constraints.maxHeight - 220,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final campanhaItem = controller.campanhas[index];
                            final individualPerformanceItem = controller
                                .getPerformanceIndividualByCampanhaId(
                                  campanhaItem.campanhaId,
                                );
                            final equipePerformanceItem = controller
                                .getPerformanceEquipeByCampanhaId(
                                  campanhaItem.campanhaId,
                                );
                            return CampanhaCardWidget(
                              campanha: campanhaItem,
                              performaceIndividual: individualPerformanceItem,
                              performaceEquipe: equipePerformanceItem,
                            );
                          },
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 16),
                          itemCount: controller.campanhas.length,
                        ),
                      ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
