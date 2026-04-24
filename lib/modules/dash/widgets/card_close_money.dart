import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/domain/models/cartoes_model.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardCloseMoney extends StatelessWidget {
  final CartoesModel model;
  final VoidCallback onPressed;
  const CardCloseMoney({
    super.key,
    required this.model,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: PostoAppUiConfigurations.blueMediumColor,
                        size: 30,
                      ),
                    ),
                    Text(
                      UtilBrasilFields.obterReal(model.diferencaTotal),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Fechamento Caixa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                const SizedBox(height: 12),
                _BulletItem(
                  color: Colors.blue,
                  label: 'Cartões deletados: ${model.cartoesDeletados}',
                ),
                const SizedBox(height: 6),
                _BulletItem(
                  color: Colors.orange,
                  label: 'Cartões vinculados: ${model.cartoesVinculados}',
                ),
                const SizedBox(height: 6),
                _BulletItem(
                  color: Colors.blue,
                  label: 'Cartões corrigidos: ${model.cartoesCorrigidos}',
                ),
                const SizedBox(height: 6),
                _BulletItem(
                  color: Colors.orange,
                  label: 'Cartões inseridos: ${model.cartoesInseridos}',
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 10),
                _PenalidadeRow(valor: model.penalidade.toDouble()),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ButtonCardWidget(onPressed: onPressed),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final Color color;
  final String label;

  const _BulletItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _PenalidadeRow extends StatelessWidget {
  final double valor;

  const _PenalidadeRow({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Penalidade',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          valor.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valor < 0
                ? Colors.red.shade700
                : PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ],
    );
  }
}
