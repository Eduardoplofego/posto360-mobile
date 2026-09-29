import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CampoDateWidget extends StatelessWidget {
  final ChamadoCampoModel campo;

  const CampoDateWidget({super.key, required this.campo});

  static final DateFormat _format = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final data = DateTime.tryParse(campo.valorTexto ?? '');
    final isEmpty = data == null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 14,
            color: isEmpty
                ? PostoAppUiConfigurations.darkGreyColor
                : PostoAppUiConfigurations.blueMediumColor,
          ),
          const SizedBox(width: 8),
          Text(
            isEmpty ? (campo.placeholder ?? 'Sem resposta') : _format.format(data),
            style: TextStyle(
              fontSize: 14,
              color: isEmpty
                  ? PostoAppUiConfigurations.darkGreyColor
                  : PostoAppUiConfigurations.textDarkColor,
              fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
