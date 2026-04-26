import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/equipe/widgets/membro_equipe_card_widget.dart';
import './equipe_controller.dart';

class EquipePage extends GetView<EquipeController> {
  const EquipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Equipe',
          leading: BackIconButtonWidget(onPressed: () => Get.back()),
          actions: const [],
        ),
      ),
      body: RefreshIndicator.noSpinner(
        onRefresh: controller.onRefresh,
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  color: PostoAppUiConfigurations.blueMediumColor,
                ),
              ),
            );
          }
          if (controller.hasError) {
            return _ErrorState(
              message: controller.errorMessage,
              onRetry: controller.onRefresh,
            );
          }
          final list = controller.membros;
          if (list.isEmpty) {
            return const _EmptyState();
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Text(
                '${list.length} colaboradores',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PostoAppUiConfigurations.greyColor,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              ...list.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MembroEquipeCardWidget(
                    membro: m,
                    onPressed: () {
                      Get.toNamed('/equipe/colaborador/${m.id}');
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 56,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum colaborador encontrado',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Puxe para atualizar.',
              style: TextStyle(
                fontSize: 12,
                color: PostoAppUiConfigurations.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: PostoAppUiConfigurations.greyColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
