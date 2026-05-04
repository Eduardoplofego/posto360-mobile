import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';

class ProcedimentoCardWidget extends StatelessWidget {
  final ProcedimentoModel procedimento;
  final VoidCallback onPressed;

  const ProcedimentoCardWidget({
    super.key,
    required this.procedimento,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final nome = procedimento.nome.replaceAll('\n', ' ').trim();
    final temDescricao = procedimento.descricao.trim().isNotEmpty;
    final totalEtapas = procedimento.etapas.length;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightGreyBgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          spacing: 14,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_gas_station_outlined,
                color: PostoAppUiConfigurations.blueMediumColor,
                size: 26,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: PostoAppUiConfigurations.textDarkColor,
                      height: 1.25,
                    ),
                  ),
                  if (temDescricao) ...[
                    const SizedBox(height: 4),
                    Text(
                      procedimento.descricao,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  if (totalEtapas > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.list_alt_outlined,
                          size: 13,
                          color: PostoAppUiConfigurations.blueMediumColor,
                        ),
                        Text(
                          '$totalEtapas ${totalEtapas == 1 ? "etapa" : "etapas"}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: PostoAppUiConfigurations.blueMediumColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          ],
        ),
      ),
    );
  }
}
