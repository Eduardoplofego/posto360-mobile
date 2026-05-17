import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/dash/widgets/card_campanhas_widget.dart';
import 'package:posto360/modules/dash/widgets/card_close_money.dart';
import 'package:posto360/modules/dash/widgets/card_detailed_widget.dart';
import 'package:posto360/modules/dash/widgets/card_resume_widget.dart';
import 'package:posto360/modules/dash/widgets/card_rh_widget.dart';
import './colaborador_detalhe_controller.dart';

class ColaboradorDetalhePage extends GetView<ColaboradorDetalheController> {
  const ColaboradorDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Colaborador',
        leading: BackIconButtonWidget(onPressed: () => Get.back()),
        actions: const [],
      ),
      body: RefreshIndicator.noSpinner(
        onRefresh: controller.onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingUser,
                  height: 80,
                  initDelay: 50,
                  child: _ColaboradorHeader(user: controller.user),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => CardResumeWidget(
                  premioFuncao: controller.user?.premioFuncao ?? 0,
                  premioCampanhas: controller.dashboardModel.bonificacaoTotal,
                  penalidades: controller.penalidadeTotal,
                ),
              ),
              const SizedBox(height: 17),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingCampanhas,
                  height: 200,
                  initDelay: 100,
                  child: CardCampanhasWidget(
                    onPressed: null,
                    campanhasAtivas: controller.dashboardModel.campanhasAtivas,
                    bonificacaoTotal:
                        controller.dashboardModel.bonificacaoTotal,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingHorario,
                  height: 190,
                  initDelay: 150,
                  child: CardRhWidget(model: controller.horario),
                ),
              ),
              const SizedBox(height: 17),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingCartoes,
                  height: 190,
                  initDelay: 200,
                  child: CardCloseMoney(model: controller.cartoes),
                ),
              ),
              const SizedBox(height: 17),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingCursos,
                  height: 190,
                  initDelay: 250,
                  child: CardDetailedWidget(
                    icon: Icons.school_outlined,
                    totalNumber:
                        controller.dashboardModel.cursosConcluidos.toInt(),
                    title: 'Performance Cursos',
                    totalNumberDetailed:
                        controller.dashboardModel.totalCursos.toInt(),
                    totalNumberDetailedText: 'cursos',
                    totalTakeNumberDetailedText: 'concluídos',
                    penalidade: controller.dashboardModel.penalidadeCursos,
                    hideTrendingDetail: true,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Obx(
                () => CardLoadingWidget(
                  isLoading: controller.loadingChecklists,
                  height: 190,
                  initDelay: 300,
                  child: CardDetailedWidget(
                    icon: Icons.checklist_sharp,
                    totalNumber:
                        controller.dashboardModel.checklistsConcluidas.toInt(),
                    title: 'Performance Checklists',
                    totalNumberDetailed:
                        controller.dashboardModel.totalChecklist.toInt(),
                    totalNumberDetailedText: 'checklists',
                    totalTakeNumberDetailedText: 'concluídos',
                    penalidade: controller.dashboardModel.penalidadeChecklists,
                    hideTrendingDetail: true,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColaboradorHeader extends StatelessWidget {
  final UserModel? user;

  const _ColaboradorHeader({required this.user});

  String _initial(String nome) =>
      nome.isNotEmpty ? nome.trim()[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final nome = user?.name ?? '';
    final sobrenome = user?.lastName ?? '';
    final fullName = '$nome ${sobrenome.isNotEmpty ? sobrenome : ''}'.trim();
    final funcao = user?.tipoUsuario ?? '';
    final filial = user?.idFilial != null ? 'Filial ${user!.idFilial}' : '';
    final photoUrl = user?.photoUrl ?? '';

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 60,
            height: 60,
            color: PostoAppUiConfigurations.lightPurpleColor,
            child: photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    cacheHeight: 60,
                    cacheWidth: 60,
                    errorBuilder: (_, __, ___) => _avatarFallback(nome),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _avatarFallback(nome),
                  )
                : _avatarFallback(nome),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fullName.isEmpty ? '—' : fullName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                [funcao, filial].where((e) => e.isNotEmpty).join(' · '),
                style: TextStyle(
                  fontSize: 12,
                  color: PostoAppUiConfigurations.greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback(String nome) {
    return Center(
      child: Text(
        _initial(nome),
        style: TextStyle(
          color: PostoAppUiConfigurations.blueMediumColor,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
    );
  }
}
