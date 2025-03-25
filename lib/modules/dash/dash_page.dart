import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/notification_icon_button_widget.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: controller.onRefresh,
          backgroundColor: Colors.white,
          color: PostoAppUiConfigurations.blueMediumColor,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              ProfileCardWidget(),
              const SizedBox(height: 26),
              WorkingDayWidget(),
              const SizedBox(height: 28),
              DashboardSectionHeaderWidget(),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Obx(() {
                return CardDetailedWidget(
                  icon: Icons.event_busy_outlined,
                  totalNumber: controller.horarioFaltasAtrasos.faltas,
                  title: 'Número de faltas',
                  totalNumberDetailed: controller.daysRegistered,
                  totalNumberDetailedText: 'dias registrados',
                  totalTakeNumberDetailedText: 'dias com falta',
                );
              }),
              const SizedBox(height: 17),
              Obx(() {
                return CardDetailedWidget(
                  icon: Icons.timer_off_outlined,
                  totalNumber: controller.horarioFaltasAtrasos.atrasos,
                  title: 'Número de atrasos',
                  totalNumberDetailed: controller.daysRegistered,
                  totalNumberDetailedText: 'dias registrados',
                  totalTakeNumberDetailedText: 'dias com atraso',
                );
              }),
              const SizedBox(height: 17),
              Obx(() {
                return CardDetailedWidget(
                  icon: Icons.speed_outlined,
                  totalNumber: controller.horarioFaltasAtrasos.atrasos,
                  title: 'Performance Produtos Incentivados',
                  totalNumberDetailed: controller.daysRegistered,
                  totalNumberDetailedText: 'Meta',
                  totalTakeNumberDetailedText: 'Realizado',
                  hideNumberDetailed: true,
                  onPressed: () {
                    Get.toNamed('/campanhas');
                  },
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
