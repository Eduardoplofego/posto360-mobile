import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/core/ui/widgets/select_date_widget.dart';
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
              await controller.saveControllerOnBackground();
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: Colors.white,
        color: PostoAppUiConfigurations.blueMediumColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            return ListView(
              children: [
                const SizedBox(height: 16),
                CardLoadingWidget(
                  isLoading: controller.isLoading,
                  height: 120,
                  initDelay: 50,
                  child: CardTotalBonusWidget(),
                ),
                const SizedBox(height: 8),
                SelectDateWidget(
                  nextMonthPressed: controller.nextMonth,
                  period: controller.monthSelected,
                  hasNextMonth: controller.hasNextMonth,
                  prevMonthPressed: controller.prevMonth,
                ),
                const SizedBox(height: 8),
                controller.isLoading
                    ? Column(
                      children: [
                        CardLoadingWidget(
                          isLoading: controller.isLoading,
                          height: 400,
                          initDelay: 100,
                          child: const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),
                        CardLoadingWidget(
                          isLoading: controller.isLoading,
                          height: 400,
                          initDelay: 200,
                          child: const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),
                        CardLoadingWidget(
                          isLoading: controller.isLoading,
                          height: 400,
                          initDelay: 250,
                          child: const SizedBox.shrink(),
                        ),
                      ],
                    )
                    : Column(
                      spacing: 16,
                      children:
                          controller.campanhas.isNotEmpty
                              ? controller.loadCampanhaCards()
                              : [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Nenhuma campanha listada\n para esse período',
                                  ),
                                ),
                              ],
                    ),
                const SizedBox(height: 32),
              ],
            );
          }),
        ),
      ),
    );
  }
}
