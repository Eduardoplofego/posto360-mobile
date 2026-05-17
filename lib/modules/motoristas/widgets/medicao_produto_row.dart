import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/motoristas/domain/models/produto_medicao_model.dart';
import 'package:posto360/modules/motoristas/widgets/capacidade_circulo_widget.dart';

class MedicaoProdutoRow extends StatelessWidget {
  final ProdutoMedicaoModel produto;

  const MedicaoProdutoRow({super.key, required this.produto});

  static final NumberFormat _volumeFormat =
      NumberFormat.decimalPattern('pt_BR');

  String _formatVolume(double volume) =>
      '${_volumeFormat.format(volume.round())} L';

  @override
  Widget build(BuildContext context) {
    final pct = produto.percentualOcupacao;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _valor(
                      label: '00h',
                      value: _formatVolume(produto.volumeMeiaNoite),
                      bold: false,
                    ),
                    const SizedBox(width: 12),
                    _valor(
                      label: 'Atual',
                      value: _formatVolume(produto.volumeAtual),
                      bold: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (pct != null) ...[
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CapacidadeCirculoWidget(percentual: pct, size: 38),
                const SizedBox(height: 2),
                Text(
                  _formatVolume(produto.capacidade!),
                  style: TextStyle(
                    fontSize: 10,
                    color: PostoAppUiConfigurations.greyColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _valor({
    required String label,
    required String value,
    required bool bold,
  }) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(
            fontSize: 11,
            color: PostoAppUiConfigurations.greyColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold
                ? PostoAppUiConfigurations.blueMediumColor
                : PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ],
    );
  }
}
