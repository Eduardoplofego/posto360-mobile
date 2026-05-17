import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/motoristas/domain/models/carregamento_model.dart';

class CarregamentoTile extends StatelessWidget {
  final CarregamentoModel carregamento;
  final bool exibirData;

  const CarregamentoTile({
    super.key,
    required this.carregamento,
    this.exibirData = false,
  });

  static final NumberFormat _volumeFormat =
      NumberFormat.decimalPattern('pt_BR');
  static final DateFormat _dataFormat = DateFormat('dd/MM', 'pt_BR');

  String _formatVolume(double volume) =>
      '${_volumeFormat.format(volume.round())} L';

  String _headerText() {
    final partes = <String>[];
    if (exibirData) {
      partes.add(_dataFormat.format(carregamento.dataCarregamento));
    }
    if (carregamento.horarioPrevisto != null &&
        carregamento.horarioPrevisto!.isNotEmpty) {
      partes.add(carregamento.horarioPrevisto!);
    }
    return partes.isEmpty ? 'Sem horário previsto' : partes.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 16,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              const SizedBox(width: 6),
              Text(
                _headerText(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
              ),
              const Spacer(),
              Text(
                _formatVolume(carregamento.volumeTotal),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PostoAppUiConfigurations.greyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...carregamento.pedidos.map(
            (pedido) => Padding(
              padding: const EdgeInsets.only(top: 2, left: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      pedido.produtoNome,
                      style: TextStyle(
                        fontSize: 12,
                        color: PostoAppUiConfigurations.textDarkColor,
                      ),
                    ),
                  ),
                  Text(
                    _formatVolume(pedido.volume),
                    style: TextStyle(
                      fontSize: 12,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
