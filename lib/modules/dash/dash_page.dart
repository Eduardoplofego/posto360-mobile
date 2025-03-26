import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/notification_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/dash/widgets/profile_card_widget.dart';
import 'package:posto360/modules/dash/widgets/card_detailed_widget.dart';
import 'package:posto360/modules/dash/widgets/dashboard_section_header_widget.dart';
import 'package:posto360/modules/dash/widgets/working_day_widget.dart';
import 'dash_controller.dart';

class DashPage extends GetView<DashController> {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Obx(() {
          return CustomAppBar(
            title: 'Dashboard',
            leading: MenuIconButtonWidget(
              onPressed: () {
                controller.scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              NotificationIconButtonWidget(
                onPressed: () {},
                hasNotification: controller.hasNotification,
              ),
            ],
          );
        }),
      ),
      drawer: PostoAppDrawer(
        autheticatedUser: Get.find<AuthService>().getUser()!,
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: Colors.white,
        color: PostoAppUiConfigurations.blueMediumColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            backgroundColor: Colors.white,
            color: PostoAppUiConfigurations.blueMediumColor,
            child: ListView(
              children: [
                const SizedBox(height: 8),
                Obx(() {
                  return CardLoadingWidget(
                    isLoading: controller.isLoading,
                    height: 80,
                    initDelay: 50,
                    child: ProfileCardWidget(),
                  );
                }),
                const SizedBox(height: 26),
                Obx(() {
                  return CardLoadingWidget(
                    isLoading: controller.isLoading,
                    height: 100,
                    initDelay: 150,
                    child: WorkingDayWidget(),
                  );
                }),
                const SizedBox(height: 28),
                DashboardSectionHeaderWidget(),
                const SizedBox(height: 16),
                Obx(() {
                  return CardLoadingWidget(
                    isLoading: controller.isLoading,
                    height: 190,
                    initDelay: 200,
                    child: CardDetailedWidget(
                      icon: Icons.event_busy_outlined,
                      totalNumber: controller.horarioFaltasAtrasos.faltas,
                      title: 'Número de faltas',
                      totalNumberDetailed: controller.daysRegistered,
                      totalNumberDetailedText: 'dias registrados',
                      totalTakeNumberDetailedText: 'dias com falta',
                    ),
                  );
                }),
                const SizedBox(height: 17),
                Obx(() {
                  return CardLoadingWidget(
                    isLoading: controller.isLoading,
                    height: 190,
                    initDelay: 250,
                    child: CardDetailedWidget(
                      icon: Icons.timer_off_outlined,
                      totalNumber: controller.horarioFaltasAtrasos.atrasos,
                      title: 'Número de atrasos',
                      totalNumberDetailed: controller.daysRegistered,
                      totalNumberDetailedText: 'dias registrados',
                      totalTakeNumberDetailedText: 'dias com atraso',
                    ),
                  );
                }),
                const SizedBox(height: 17),
                Obx(() {
                  return CardLoadingWidget(
                    isLoading: controller.isLoading,
                    height: 200,
                    initDelay: 300,
                    child: CardDetailedWidget(
                      icon: Icons.speed_outlined,
                      totalNumber: controller.horarioFaltasAtrasos.atrasos,
                      title: 'Performance Produtos Incentivados',
                      totalNumberDetailed: controller.daysRegistered,
                      totalNumberDetailedText: 'Meta',
                      totalTakeNumberDetailedText: 'Realizado',
                      hideNumberDetailed: true,
                      hideTrendingDetail: true,
                      onPressed: () {
                        Get.toNamed('/campanhas');
                      },
                    ),
                  );
                }),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
