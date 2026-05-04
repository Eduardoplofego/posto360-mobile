import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardCampanhasWidget extends StatelessWidget {
  final int campanhasAtivas;
  final double bonificacaoTotal;
  final VoidCallback? onPressed;

  const CardCampanhasWidget({
    super.key,
    required this.onPressed,
    required this.campanhasAtivas,
    required this.bonificacaoTotal,
  });

  @override
  Widget build(BuildContext context) {
    final hasButton = onPressed != null;
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(16, 12, hasButton ? 0 : 16, hasButton ? 0 : 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: hasButton ? 16 : 0),
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
                        Icons.local_offer_outlined,
                        color: PostoAppUiConfigurations.blueMediumColor,
                        size: 30,
                      ),
                    ),
                    Text(
                      campanhasAtivas.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Produtos Incentivados',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 10),
                _PremiacaoRow(valor: bonificacaoTotal),
              ],
            ),
          ),
          if (hasButton) ...[
            const SizedBox(height: 12),
            ButtonCardWidget(onPressed: onPressed!),
          ],
        ],
      ),
    );
  }
}

class _PremiacaoRow extends StatelessWidget {
  final double valor;

  const _PremiacaoRow({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Premiação conquistada',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          UtilBrasilFields.obterReal(valor),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ],
    );
  }
}
