import 'package:flutter/material.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CampoSelectWidget extends StatelessWidget {
  final ChamadoCampoModel campo;

  const CampoSelectWidget({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    final valor = (campo.valorTexto ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  valor.isEmpty ? 'Sem resposta' : valor,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: valor.isEmpty
                        ? FontWeight.w400
                        : FontWeight.w600,
                    color: valor.isEmpty
                        ? PostoAppUiConfigurations.darkGreyColor
                        : PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 20,
                color: PostoAppUiConfigurations.darkGreyColor,
              ),
            ],
          ),
        ),
        if (campo.opcoes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: campo.opcoes.map((op) {
              final selected = op == valor;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? PostoAppUiConfigurations.lightPurpleColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: selected
                        ? PostoAppUiConfigurations.blueMediumColor
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  op,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? PostoAppUiConfigurations.blueMediumColor
                        : PostoAppUiConfigurations.greyColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
