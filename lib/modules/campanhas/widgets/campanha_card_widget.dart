import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/type_bonificacao.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';

class CampanhaCardWidget extends StatelessWidget {
  final CampanhaModel campanha;
  final PerformanceIndividualModel performaceIndividual;
  final PerformanceEquipeModel performaceEquipe;

  const CampanhaCardWidget({
    super.key,
    required this.campanha,
    required this.performaceIndividual,
    required this.performaceEquipe,
  });

  @override
  Widget build(BuildContext context) {
    final isUnidade = campanha.tipoBonificacao == TypeBonificacao.unidade;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            campanha.nomeCampanha,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (campanha.descricao.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              campanha.descricao,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Apuração por ${campanha.tipoBonificacao.description().toLowerCase()}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          _PerformanceSection(
            title: 'Performance Individual',
            icon: Icons.person_outline,
            accent: PostoAppUiConfigurations.blueMediumColor,
            details: [
              _DetailRow(
                label: 'Meta',
                value: isUnidade
                    ? '${campanha.metaIndividual.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(campanha.metaIndividual),
              ),
              _DetailRow(
                label: 'Valor por meta',
                value: UtilBrasilFields.obterReal(campanha.bonificacaoIndividual),
              ),
              _DetailRow(
                label: 'Vendas',
                value: isUnidade
                    ? '${campanha.resultadoIndividual.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(campanha.resultadoIndividual),
              ),
              _DetailRow(
                label: 'Premiação conquistada',
                value: UtilBrasilFields.obterReal(
                  campanha.bonificacaoIndividualConquistada,
                ),
                bold: true,
              ),
            ],
            progresso: performaceIndividual.progresso,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 16),
          _PerformanceSection(
            title: 'Performance Equipe',
            icon: Icons.groups_2_outlined,
            accent: PostoAppUiConfigurations.orangeColor,
            details: [
              _DetailRow(
                label: 'Meta',
                value: isUnidade
                    ? '${campanha.metaEquipe.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(campanha.metaEquipe),
              ),
              _DetailRow(
                label: 'Valor por meta',
                value: UtilBrasilFields.obterReal(
                  performaceEquipe.bonificacaoMetaValor,
                ),
              ),
              _DetailRow(
                label: 'Vendas',
                value: isUnidade
                    ? '${campanha.resultadoEquipe.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(campanha.resultadoEquipe),
              ),
              _DetailRow(
                label: 'Premiação conquistada',
                value: UtilBrasilFields.obterReal(
                  campanha.bonificacaoEquipeConquistada,
                ),
                bold: true,
              ),
            ],
            progresso: performaceEquipe.progresso,
          ),
        ],
      ),
    );
  }
}

class _PerformanceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final List<_DetailRow> details;
  final double progresso;

  const _PerformanceSection({
    required this.title,
    required this.icon,
    required this.accent,
    required this.details,
    required this.progresso,
  });

  @override
  Widget build(BuildContext context) {
    final cycles = progresso ~/ 100;
    final remaining = (progresso - cycles * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...details,
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Realizado',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Spacer(),
            if (cycles >= 1) ...[
              _CycleBadge(cycles: cycles, color: accent),
              const SizedBox(width: 8),
            ],
            Text(
              '$remaining%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: remaining / 100,
            backgroundColor: Colors.white,
            color: accent,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: PostoAppUiConfigurations.textDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleBadge extends StatelessWidget {
  final int cycles;
  final Color color;

  const _CycleBadge({required this.cycles, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            '${cycles}x',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
