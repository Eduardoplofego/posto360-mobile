import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/fechamento-caixa/cartoes_detalhes_controller.dart';
import 'package:posto360/modules/fechamento-caixa/domain/widgets/cartao_discrepancia_card_widget.dart';

class CartoesDetalhesScreen extends GetView<CartoesDetalhesController> {
  const CartoesDetalhesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dia = controller.dia;
    final diaFormatado =
        dia == null ? '' : DateFormat('dd/MM/yyyy').format(dia);

    return Scaffold(
      appBar: CustomAppBar(
        title: diaFormatado.isEmpty ? 'Cartões' : 'Cartões - $diaFormatado',
        leading: const BackIconButtonWidget(),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (controller.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            );
          }

          if (controller.cartoes.isEmpty) {
            return const _EstadoVazio();
          }

          return RefreshIndicator(
            onRefresh: controller.carregarCartoes,
            color: PostoAppUiConfigurations.blueMediumColor,
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              itemCount: controller.cartoes.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _ResumoDoDia(
                    total: controller.totalCartoes,
                    totalPorStatus: controller.totalPorStatus,
                  );
                }
                return CartaoDiscrepanciaCardWidget(
                  cartao: controller.cartoes[index - 1],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _ResumoDoDia extends StatelessWidget {
  final int total;
  final Map<String, int> totalPorStatus;

  const _ResumoDoDia({required this.total, required this.totalPorStatus});

  @override
  Widget build(BuildContext context) {
    final descricao =
        total == 1
            ? '1 divergência resolvida neste dia'
            : '$total divergências resolvidas neste dia';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.credit_card,
              size: 16,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
            const SizedBox(width: 6),
            Text(
              descricao,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (totalPorStatus.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            totalPorStatus.entries
                .map((e) => '${e.value} ${e.key.toLowerCase()}')
                .join(' · '),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ],
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, color: Colors.grey, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Nenhuma divergência de cartão neste dia',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
