import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/back_icon_button_widget.dart';
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
            onPressed: () {
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          return controller.isLoading
              ? const SizedBox.shrink()
              : ListView(
                children: [
                  const SizedBox(height: 16),
                  CardTotalBonusWidget(),
                  const SizedBox(height: 16),
                  SelectDateWidget(
                    withBackground: true,
                    extendBody: true,
                    period: controller.periodSelectedString,
                  ),
                  const SizedBox(height: 16),
                  Column(
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
    );
  }
}
