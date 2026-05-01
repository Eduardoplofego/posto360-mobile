import 'package:flutter/material.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CampoTextWidget extends StatelessWidget {
  final ChamadoCampoModel campo;

  const CampoTextWidget({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    final valor = (campo.valorTexto ?? '').trim();
    final isEmpty = valor.isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        isEmpty ? (campo.placeholder ?? 'Sem resposta') : valor,
        style: TextStyle(
          fontSize: 14,
          color: isEmpty
              ? PostoAppUiConfigurations.darkGreyColor
              : PostoAppUiConfigurations.textDarkColor,
          fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
    );
  }
}
