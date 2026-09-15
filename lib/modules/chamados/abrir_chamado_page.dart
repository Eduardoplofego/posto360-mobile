import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/widgets/template_card_widget.dart';
import 'package:posto360/modules/core/domain/services/filiais_acesso_service.dart';
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
        leading: const BackIconButtonWidget(),
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
                  if (controller.precisaEscolherFilial) ...[
                    const SizedBox(height: 16),
                    _FilialSelector(
                      filiais: controller.filiais,
                      selecionadaId: controller.filialSelecionadaId,
                      onChanged: controller.selecionarFilial,
                    ),
                  ],
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
                        onPressed: () => _abrir(context, t),
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

  Future<void> _abrir(BuildContext context, ChamadoTemplateModel template) async {
    if (controller.isSubmitting) return;
    final impedimento = controller.impedimentoParaAbrir;
    if (impedimento != null) {
      _mostrarAviso(context, impedimento);
      return;
    }
    final confirmed = await _confirmarAbertura(template);
    if (confirmed != true) return;
    final result = await controller.abrir(
      template: template,
      titulo: template.nome,
    );
    if (!result.ok) {
      if (!context.mounted) return;
      _mostrarAviso(context, result.error ?? 'Tente novamente.');
      return;
    }
    if (result.chamadoId != null) {
      Get.offNamed('/editar-chamado/${result.chamadoId}');
    } else {
      if (context.mounted) Navigator.of(context).maybePop();
    }
  }

  void _mostrarAviso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: TextStyle(color: PostoAppUiConfigurations.textDarkColor),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
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
            if (controller.filialSelecionadaNome != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.local_gas_station_outlined,
                    size: 15,
                    color: PostoAppUiConfigurations.blueMediumColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      controller.filialSelecionadaNome!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PostoAppUiConfigurations.textDarkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        actions: [
          Builder(
            builder: (ctx) => TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: PostoAppUiConfigurations.greyColor,
              ),
              child: const Text('Cancelar'),
            ),
          ),
          Builder(
            builder: (ctx) => ElevatedButton.icon(
              onPressed: () => Navigator.of(ctx).pop(true),
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
          ),
        ],
      ),
    );
  }
}

class _FilialSelector extends StatelessWidget {
  final List<FilialAcessoModel> filiais;
  final int? selecionadaId;
  final ValueChanged<int?> onChanged;

  const _FilialSelector({
    required this.filiais,
    required this.selecionadaId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(
                Icons.local_gas_station_outlined,
                size: 18,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              Text(
                'Filial do chamado',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (filiais.isEmpty)
            Text(
              'Nenhuma filial disponível. Volte para a tela de filiais, '
              'atualize e tente de novo.',
              style: TextStyle(
                fontSize: 12,
                color: PostoAppUiConfigurations.greyColor,
                height: 1.35,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selecionadaId,
                  borderRadius: BorderRadius.circular(10),
                  hint: Text(
                    'Selecione a filial',
                    style: TextStyle(
                      fontSize: 13,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                  ),
                  icon: Icon(
                    Icons.expand_more_rounded,
                    color: PostoAppUiConfigurations.blueMediumColor,
                  ),
                  items: filiais
                      .map(
                        (filial) => DropdownMenuItem<int>(
                          value: filial.id,
                          child: Text(
                            filial.nome,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PostoAppUiConfigurations.textDarkColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
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
