import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/widgets/campo_card_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import './chamado_detalhe_controller.dart';

class ChamadoDetalhePage extends GetView<ChamadoDetalheController> {
  const ChamadoDetalhePage({super.key});

  Future<void> _abrirEdicao() async {
    await Get.toNamed(
      '/editar-chamado/${controller.chamadoId}',
      arguments: controller.chamado,
    );
    await controller.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final podeEditar = controller.chamado?.podeEditar ?? false;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chamado',
        leading: const BackIconButtonWidget(),
        actions: [
          if (podeEditar) _EditarButton(onPressed: _abrirEdicao),
        ],
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

          final chamado = controller.chamado;
          final campos = controller.campos;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              if (chamado != null) _Hero(chamado: chamado),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Respostas do chamado',
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
                      '${campos.where((c) => c.hasResposta).length}/${campos.length}',
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
              if (campos.isEmpty)
                const _EmptyCamposState()
              else
                ...campos.map(
                  (campo) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CampoCardWidget(campo: campo),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _EditarButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const _EditarButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
      label: const Text(
        'Editar',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final ChamadoModel chamado;

  const _Hero({required this.chamado});

  @override
  Widget build(BuildContext context) {
    final dataFmt = DateFormat('dd/MM/yyyy');
    final dataValidade = chamado.dataValidade;
    final dataDesignacao = chamado.dataDesignacao;
    final filialNome = chamado.abertoPor?.filial?.nome ?? '';
    final abertoPorNome = chamado.abertoPor?.nome ?? '';
    final templateColor = chamado.color;

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: templateColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      chamado.nomeTemplate.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _StatusChipHero(status: chamado.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            chamado.titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          if (chamado.descricaoTemplate.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              chamado.descricaoTemplate,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (abertoPorNome.isNotEmpty)
                _HeroInfo(icon: Icons.person_outline, label: abertoPorNome),
              if (filialNome.isNotEmpty)
                _HeroInfo(icon: Icons.business_outlined, label: filialNome),
              if (dataDesignacao != null)
                _HeroInfo(
                  icon: Icons.schedule_outlined,
                  label: 'Aberto em ${dataFmt.format(dataDesignacao)}',
                ),
              if (dataValidade != null)
                _HeroInfo(
                  icon: Icons.event_outlined,
                  label: 'Vence em ${dataFmt.format(dataValidade)}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChipHero extends StatelessWidget {
  final String status;

  const _StatusChipHero({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: PostoAppUiConfigurations.blueMediumColor,
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
