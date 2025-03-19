import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/notification_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/posto_app_bar.dart';
import 'package:posto360/core/ui/widgets/profile/profile_appbar_widget.dart';
import 'package:posto360/modules/dash/widgets/card_detailed_widget.dart';
import 'package:posto360/modules/dash/widgets/dashboard_section_header_widget.dart';
import 'package:posto360/modules/dash/widgets/working_day_widget.dart';
import 'dash_controller.dart';

class DashPage extends GetView<DashController> {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: pesquisar icones corretos

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(145),
        child: PostoAppBar(
          leading: MenuIconButtonWidget(onPressed: () {}),
          actions: [NotificationIconButtonWidget(onPressed: () {})],
          bottomAppbar: ProfileCardAppBar(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(height: 26),
                WorkingDayWidget(),
                const SizedBox(height: 28),
                DashboardSectionHeaderWidget(),
                const SizedBox(height: 16),
                CardDetailedWidget(
                  icon: Icons.calendar_today_sharp,
                  totalNumber: 4,
                  title: 'Número de faltas',
                  isGoodPerformance: true,
                  totalNumberDetailed: 18,
                  totalNumberDetailedText: 'dias registrados',
                  totalTakeNumberDetailedText: 'dias com falta',
                  onPressed: () {},
                ),
                const SizedBox(height: 17),
                CardDetailedWidget(
                  icon: Icons.timelapse_sharp,
                  totalNumber: 12,
                  title: 'Número de atrasos',
                  isGoodPerformance: false,
                  totalNumberDetailed: 18,
                  totalNumberDetailedText: 'dias registrados',
                  totalTakeNumberDetailedText: 'dias com atraso',
                ),
                const SizedBox(height: 17),
                CardDetailedWidget(
                  icon: Icons.timelapse_sharp,
                  totalNumber: 12,
                  title: 'Número de atrasos',
                  isGoodPerformance: false,
                  totalNumberDetailed: 18,
                  totalNumberDetailedText: 'dias registrados',
                  totalTakeNumberDetailedText: 'dias com atraso',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
