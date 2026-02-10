import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/dash/widgets/card_campanhas_widget.dart';
import 'package:posto360/modules/dash/widgets/card_close_money.dart';
import 'package:posto360/modules/dash/widgets/card_resume_widget.dart';
import 'package:posto360/modules/dash/widgets/card_rh_widget.dart';
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
      body: RefreshIndicator.noSpinner(
        onRefresh: controller.onRefresh,
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        CardResumeWidget(
                          premioFuncao:
                              controller.autheticatedUser.premioFuncao,
                          premioCampanhas:
                              controller.dashboardModel.bonificacaoTotal,
                          penalidades: controller.penalidadeTotal,
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
                            child: CardCampanhasWidget(
                              onPressed: () {
                                Get.toNamed('/campanhas');
                              },
                              campanhasAtivas:
                                  controller.dashboardModel.campanhasAtivas,
                              bonificacaoTotal:
                                  controller.dashboardModel.bonificacaoTotal,
                            ),
                          ),
                          const SizedBox(height: 17),
                          CardLoadingWidget(
                            isLoading: controller.loadingWork,
                            height: 190,
                            initDelay: 200,
                            child: CardRhWidget(
                              model: controller.horarioFaltasAtrasos,
                            ),
                          ),
                          const SizedBox(height: 17),
                          CardLoadingWidget(
                            isLoading: controller.loadingWork,
                            height: 190,
                            initDelay: 200,
                            child: CardCloseMoney(
                              model: controller.cartoesModel,
                              onPressed: () {
                                Get.toNamed('/fechamento-caixa');
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
                              penalidade:
                                  controller.dashboardModel.penalidadeCursos,
                              hideTrendingDetail: true,
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
                              penalidade:
                                  controller
                                      .dashboardModel
                                      .penalidadeChecklists,
                              hideTrendingDetail: true,
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
          );
        }),
      ),
    );
  }
}
