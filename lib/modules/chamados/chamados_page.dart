import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/widgets/chamado_card_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import './chamados_controller.dart';

class ChamadosPage extends GetView<ChamadosController> {
  const ChamadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Chamados',
          leading: BackIconButtonWidget(onPressed: () => Get.back()),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await Get.toNamed('/abrir-chamado');
                await controller.onRefresh();
              },
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
              label: const Text(
                'Novo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
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

          final list = controller.chamados;
          if (list.isEmpty) {
            return const _EmptyState();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              const _IntroBanner(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Em aberto',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PostoAppUiConfigurations.greyColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: PostoAppUiConfigurations.lightPurpleColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${list.length}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: PostoAppUiConfigurations.blueMediumColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...list.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChamadoCardWidget(
                    chamado: c,
                    onPressed: () {
                      Get.toNamed('/chamados/${c.id}', arguments: c);
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

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PostoAppUiConfigurations.blueLightColor,
            PostoAppUiConfigurations.blueMediumColor,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        spacing: 14,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.forum_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Conexão com o escritório',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Acompanhe os chamados em aberto entre a filial e o escritório.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              Icons.forum_outlined,
              size: 56,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum chamado em aberto',
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
