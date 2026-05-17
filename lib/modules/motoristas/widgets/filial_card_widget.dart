import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/motoristas/domain/models/filial_motorista_model.dart';
import 'package:posto360/modules/motoristas/widgets/carregamento_tile.dart';
import 'package:posto360/modules/motoristas/widgets/medicao_produto_row.dart';

class FilialCardWidget extends StatelessWidget {
  final FilialMotoristaModel filial;

  const FilialCardWidget({super.key, required this.filial});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PostoAppUiConfigurations.lightGreyBgColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 12),
          _medicoesSection(),
          if (filial.carregamentosHoje.isNotEmpty) ...[
            const SizedBox(height: 16),
            _sectionTitle('Carregamentos hoje', filial.carregamentosHoje.length),
            const SizedBox(height: 8),
            ...filial.carregamentosHoje.map(
              (c) => CarregamentoTile(carregamento: c),
            ),
          ],
          if (filial.proximosCarregamentos.isNotEmpty) ...[
            const SizedBox(height: 16),
            _sectionTitle(
              'Próximos carregamentos',
              filial.proximosCarregamentos.length,
            ),
            const SizedBox(height: 8),
            ...filial.proximosCarregamentos.map(
              (c) => CarregamentoTile(carregamento: c, exibirData: true),
            ),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: PostoAppUiConfigurations.lightPurpleColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.local_gas_station,
            color: PostoAppUiConfigurations.blueMediumColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filial.nome,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
              ),
              if (filial.codigo != null)
                Text(
                  'Cód. ${filial.codigo}',
                  style: TextStyle(
                    fontSize: 12,
                    color: PostoAppUiConfigurations.greyColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _medicoesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: PostoAppUiConfigurations.lightGreyBgColor,
        ),
        ...filial.produtos.map((p) => MedicaoProdutoRow(produto: p)),
      ],
    );
  }

  Widget _sectionTitle(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: PostoAppUiConfigurations.textDarkColor,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: PostoAppUiConfigurations.lightPurpleColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          ),
        ),
      ],
    );
  }
}
