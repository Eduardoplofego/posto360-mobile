import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/widgets/template_card_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import './abrir_chamado_controller.dart';

class AbrirChamadoPage extends GetView<AbrirChamadoController> {
  const AbrirChamadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Novo chamado',
        leading: BackIconButtonWidget(onPressed: () => Get.back()),
        actions: const [],
      ),
      body: Stack(
        children: [
          RefreshIndicator.noSpinner(
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

              final templates = controller.templates;
              if (templates.isEmpty) {
                return const _EmptyState();
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  const _IntroBanner(),
                  const SizedBox(height: 20),
                  Text(
                    'Selecione o tipo de chamado',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PostoAppUiConfigurations.greyColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...templates.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TemplateCardWidget(
                        template: t,
                        onPressed: () => _abrir(t),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Obx(() {
            if (!controller.isSubmitting) return const SizedBox.shrink();
            return Container(
              color: Colors.black.withValues(alpha: 0.25),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: PostoAppUiConfigurations.blueMediumColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Abrindo chamado...',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PostoAppUiConfigurations.textDarkColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _abrir(ChamadoTemplateModel template) async {
    if (controller.isSubmitting) return;
    final confirmed = await _confirmarAbertura(template);
    if (confirmed != true) return;
    final result = await controller.abrir(
      template: template,
      titulo: template.nome,
    );
    if (!result.ok) {
      Get.snackbar(
        'Não foi possível abrir o chamado',
        result.error ?? 'Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        colorText: PostoAppUiConfigurations.textDarkColor,
      );
      return;
    }
    if (result.chamadoId != null) {
      Get.offNamed('/editar-chamado/${result.chamadoId}');
    } else {
      Get.back();
    }
  }

  Future<bool?> _confirmarAbertura(ChamadoTemplateModel template) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: template.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: template.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Abrir este chamado?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.nome,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
            if (template.descricao.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                template.descricao,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              foregroundColor: PostoAppUiConfigurations.greyColor,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Get.back(result: true),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Abrir chamado'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: PostoAppUiConfigurations.blueMediumColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
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
              Icons.add_comment_outlined,
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
                  'Abrir um chamado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Escolha um tipo de chamado para começar.',
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
              Icons.inbox_outlined,
              size: 56,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum tipo de chamado disponível',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: PostoAppUiConfigurations.textDarkColor,
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
