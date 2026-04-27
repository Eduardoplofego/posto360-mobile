import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';

class ResumeCardWidget extends StatelessWidget {
  final FaltasAtrasosModel model;
  final String mesReferencia;
  const ResumeCardWidget({
    super.key,
    required this.model,
    required this.mesReferencia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 26),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.blueMediumColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/waves_card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo de $mesReferencia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          _ResumeRow(
            label: 'Faltas injustificadas',
            value: model.faltasInjustificadas.toString(),
          ),
          _ResumeRow(
            label: 'Registros incompletos',
            value: model.faltasPonto.toString(),
          ),
          _ResumeRow(
            label: 'Atrasos graves',
            value: model.atrasosGrave.toString(),
          ),
          _ResumeRow(
            label: 'Atrasos médios',
            value: model.atrasosMedio.toString(),
          ),
          _ResumeRow(
            label: 'Atrasos leves',
            value: model.atrasosLeve.toString(),
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 4),
          _ResumeRow(
            label: 'Penalidade',
            value: model.penalidade.toDouble().toStringAsFixed(2),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _ResumeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _ResumeRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.w700 : FontWeight.normal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: weight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: weight,
          ),
        ),
      ],
    );
  }
}
