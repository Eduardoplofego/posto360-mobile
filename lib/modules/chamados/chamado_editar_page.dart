import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/chamados_controller.dart';
import 'package:posto360/modules/chamados/widgets/editar_campo_card_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import './chamado_editar_controller.dart';

class ChamadoEditarPage extends GetView<ChamadoEditarController> {
  const ChamadoEditarPage({super.key});

  Future<bool> _confirmarSaida(BuildContext context, int total) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFB91C1C),
              size: 22,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Sair sem preencher?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Text(
          total == 1
              ? 'Há 1 campo obrigatório pendente. Se sair agora, o chamado ficará incompleto.'
              : 'Há $total campos obrigatórios pendentes. Se sair agora, o chamado ficará incompleto.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Continuar preenchendo'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB91C1C),
            ),
            child: const Text('Sair mesmo assim'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result == true;
  }

  Future<void> _onBackPressed(BuildContext context) async {
    final pendentes = controller.camposPendentes.length;
    if (pendentes == 0) {
      Get.back();
      return;
    }
    final ok = await _confirmarSaida(context, pendentes);
    if (ok) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final blockExit = controller.camposPendentes.isNotEmpty;
      return PopScope(
        canPop: !blockExit,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final ok = await _confirmarSaida(
            context,
            controller.camposPendentes.length,
          );
          if (ok) Get.back();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Preencher chamado',
            leading: BackIconButtonWidget(
              onPressed: () => _onBackPressed(context),
            ),
            actions: const [],
          ),
          body: _buildBody(),
        ),
      );
    });
  }

  Widget _buildBody() {
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

    final campos = controller.campos;
    final chamado = controller.chamado;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.noSpinner(
            onRefresh: controller.onRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                if (chamado != null) ...[
                  _Header(
                    titulo: chamado.titulo,
                    template: chamado.nomeTemplate,
                  ),
                  const SizedBox(height: 16),
                ],
                if (controller.camposPendentes.isNotEmpty) ...[
                  _PendingBanner(total: controller.camposPendentes.length),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Preencha os campos',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.greyColor,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                if (campos.isEmpty)
                  const _EmptyCamposState()
                else
                  ...campos.map(
                    (campo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EditarCampoCardWidget(
                        campo: campo,
                        valorAtual: controller.valorTextoAtual(campo),
                        pendente: controller.campoPendente(campo),
                        onChanged: (v) =>
                            controller.setValorTexto(campo.id, v),
                        uploads: controller.uploadsFor(campo.id),
                        isFotoMarcada: (url) =>
                            controller.isFotoMarcadaParaExclusao(campo.id, url),
                        onToggleExclusaoFoto: (url) =>
                            controller.toggleExclusaoFoto(campo.id, url),
                        onAdicionarUpload: (foto) =>
                            controller.adicionarUpload(campo.id, foto),
                        onRemoverUpload: (index) =>
                            controller.removerUpload(campo.id, index),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        _SaveBar(controller: controller),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String titulo;
  final String template;

  const _Header({required this.titulo, required this.template});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  final int total;

  const _PendingBanner({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: Color(0xFFB91C1C),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              total == 1
                  ? '1 campo obrigatório pendente'
                  : '$total campos obrigatórios pendentes',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final ChamadoEditarController controller;

  const _SaveBar({required this.controller});

  Future<void> _onPressed() async {
    final result = await controller.salvar();
    if (result.ok) {
      Get.until((route) => route.settings.name == '/chamados');
      if (Get.isRegistered<ChamadosController>()) {
        await Get.find<ChamadosController>().onRefresh();
      }
      Get.snackbar(
        'Chamado atualizado',
        'Respostas salvas com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        colorText: PostoAppUiConfigurations.textDarkColor,
      );
      return;
    }
    Get.snackbar(
      'Aviso',
      result.error ?? 'Não foi possível salvar.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      colorText: PostoAppUiConfigurations.textDarkColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => ElevatedButton.icon(
            onPressed: controller.isSaving ? null : _onPressed,
            icon: controller.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(
              controller.isSaving ? 'Salvando...' : 'Salvar respostas',
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: PostoAppUiConfigurations.blueMediumColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCamposState extends StatelessWidget {
  const _EmptyCamposState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum campo cadastrado',
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
