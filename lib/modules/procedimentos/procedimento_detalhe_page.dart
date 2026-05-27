import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/procedimentos/widgets/etapa_expansion_widget.dart';
import './procedimento_detalhe_controller.dart';

class ProcedimentoDetalhePage extends GetView<ProcedimentoDetalheController> {
  const ProcedimentoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Procedimento',
        leading: const BackIconButtonWidget(),
        actions: const [],
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

          final procedimento = controller.procedimento;
          if (procedimento == null) {
            return const _NotFoundState();
          }

          final nome = procedimento.nome.replaceAll('\n', ' ').trim();
          final temDescricao = procedimento.descricao.trim().isNotEmpty;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _Hero(nome: nome, descricao: temDescricao ? procedimento.descricao : null),
              const SizedBox(height: 20),
              ...procedimento.etapas.map(
                (etapa) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Obx(
                    () => EtapaExpansionWidget(
                      etapa: etapa,
                      expanded: controller.isEtapaExpanded(etapa.id),
                      onToggle: () => controller.toggleEtapa(etapa.id),
                    ),
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

class _Hero extends StatelessWidget {
  final String nome;
  final String? descricao;

  const _Hero({required this.nome, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PostoAppUiConfigurations.blueLightColor,
            PostoAppUiConfigurations.blueMediumColor,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'MANUAL OPERACIONAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          if (descricao != null) ...[
            const SizedBox(height: 6),
            Text(
              descricao!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Procedimento não encontrado',
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
