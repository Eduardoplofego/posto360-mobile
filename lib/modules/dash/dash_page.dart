import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/core/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/dash/widgets/empty_dashboard_model_widget.dart';
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
        child: CustomAppBar(
          title: 'Dashboard',
          leading: MenuIconButtonWidget(
            onPressed: () {
              controller.scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [],
        ),
      ),
      drawer: PostoAppDrawer(
        autheticatedUser: Get.find<AuthService>().getUser()!,
        onSavePhoto: controller.onSavePhoto,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            backgroundColor: Colors.transparent,
            elevation: 0,
            color: Colors.transparent,
            child:
                controller.isLoading
                    ? Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            color: PostoAppUiConfigurations.blueMediumColor,
                          ),
                        ),
                      ),
                    )
                    : ListView(
                      children: [
                        const SizedBox(height: 8),
                        CardLoadingWidget(
                          isLoading: controller.loadingWork,
                          height: 80,
                          initDelay: 50,
                          child: ProfileCardWidget(),
                        ),
                        const SizedBox(height: 26),
                        CardLoadingWidget(
                          isLoading: controller.loadingWork,
                          height: 100,
                          initDelay: 150,
                          child: WorkingDayWidget(),
                        ),
                        const SizedBox(height: 28),
                        DashboardSectionHeaderWidget(),
                        const SizedBox(height: 16),
                        CardLoadingWidget(
                          isLoading: controller.loadingWork,
                          height: 190,
                          initDelay: 200,
                          child: CardDetailedWidget(
                            icon: Icons.event_busy_outlined,
                            totalNumber: controller.horarioFaltasAtrasos.faltas,
                            title: 'Número de faltas',
                            totalNumberDetailed: controller.daysRegistered,
                            totalNumberDetailedText: 'dias registrados',
                            totalTakeNumberDetailedText: 'dias com falta',
                            trendingUp:
                                controller.horarioFaltasAtrasos.faltas == 0,
                          ),
                        ),
                        const SizedBox(height: 17),
                        CardLoadingWidget(
                          isLoading: controller.loadingWork,
                          height: 190,
                          initDelay: 250,
                          child: CardDetailedWidget(
                            icon: Icons.timer_off_outlined,
                            totalNumber:
                                controller.horarioFaltasAtrasos.atrasos,
                            title: 'Número de atrasos',
                            totalNumberDetailed: controller.daysRegistered,
                            totalNumberDetailedText: 'dias registrados',
                            totalTakeNumberDetailedText: 'dias com atraso',
                            trendingUp:
                                controller.horarioFaltasAtrasos.atrasos == 0,
                          ),
                        ),
                        const SizedBox(height: 17),
                        if (controller.loadingDashboardModel)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: SizedBox(
                                width: 35,
                                height: 35,
                                child: CircularProgressIndicator(
                                  color:
                                      PostoAppUiConfigurations.blueMediumColor,
                                ),
                              ),
                            ),
                          ),
                        if (controller.hasDashboardModel &&
                            !controller.loadingDashboardModel) ...[
                          CardLoadingWidget(
                            isLoading: controller.loadingDashboardModel,
                            height: 200,
                            initDelay: 300,
                            child: CardDetailedWidget(
                              icon: Icons.speed_outlined,
                              totalNumber:
                                  controller.dashboardModel.realizadoCampanhas,
                              title: 'Performance Produtos Incentivados',
                              totalNumberDetailed:
                                  controller.dashboardModel.quantidadeCampanhas,
                              totalNumberDetailedText: 'Meta',
                              totalTakeNumberDetailedText: 'Realizado',
                              hideTrendingDetail: true,
                              onPressed: () {
                                Get.toNamed('/campanhas');
                              },
                            ),
                          ),
                          const SizedBox(height: 17),
                          CardLoadingWidget(
                            isLoading: controller.loadingDashboardModel,
                            height: 190,
                            initDelay: 200,
                            child: CardDetailedWidget(
                              icon: Icons.school_outlined,
                              totalNumber:
                                  controller.dashboardModel.cursosConcluidos
                                      .toInt(),
                              title: 'Performance Cursos',
                              totalNumberDetailed:
                                  controller.dashboardModel.totalCursos.toInt(),
                              totalNumberDetailedText: 'cursos',
                              totalTakeNumberDetailedText: 'concluídos',
                              trendingUp: true,
                              onPressed: () {
                                Get.toNamed('/cursos');
                              },
                            ),
                          ),
                          const SizedBox(height: 17),
                          CardLoadingWidget(
                            isLoading: controller.loadingDashboardModel,
                            height: 190,
                            initDelay: 200,
                            child: CardDetailedWidget(
                              icon: Icons.checklist_sharp,
                              totalNumber:
                                  controller.dashboardModel.checklistsConcluidas
                                      .toInt(),
                              title: 'Performance Checklists',
                              totalNumberDetailed:
                                  controller.dashboardModel.totalChecklist
                                      .toInt(),
                              totalNumberDetailedText: 'checklists',
                              totalTakeNumberDetailedText: 'concluídos',
                              trendingUp: true,
                              onPressed: () {
                                Get.toNamed('/checklists');
                              },
                            ),
                          ),
                        ],
                        if (!controller.hasDashboardModel &&
                            !controller.loadingDashboardModel) ...[
                          EmptyDashboardModelWidget(
                            onRefresh: controller.loadDashboardModel,
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
          ),
        );
      }),
    );
  }
}
