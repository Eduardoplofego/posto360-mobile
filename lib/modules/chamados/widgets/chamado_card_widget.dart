import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class ChamadoCardWidget extends StatelessWidget {
  final ChamadoModel chamado;
  final VoidCallback? onPressed;

  const ChamadoCardWidget({super.key, required this.chamado, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final templateColor = chamado.color;
    final dataFmt = DateFormat('dd/MM/yyyy');
    final dataValidade = chamado.dataValidade;
    final dataDesignacao = chamado.dataDesignacao;
    final filialNome = chamado.abertoPor?.filial?.nome ?? '';
    final abertoPorNome = chamado.abertoPor?.nome ?? '';
    final progresso = chamado.totalCampos > 0
        ? chamado.camposRespondidos / chamado.totalCampos
        : 0.0;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightGreyBgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: templateColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              chamado.nomeTemplate,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: PostoAppUiConfigurations.greyColor,
                                letterSpacing: 0.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusChip(status: chamado.status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        chamado.titulo,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: PostoAppUiConfigurations.textDarkColor,
                          height: 1.25,
                        ),
                      ),
                      if (chamado.descricaoTemplate.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          chamado.descricaoTemplate,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (abertoPorNome.isNotEmpty)
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Aberto por',
                          value: abertoPorNome,
                        ),
                      if (filialNome.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _InfoRow(
                          icon: Icons.business_outlined,
                          label: 'Filial',
                          value: filialNome,
                        ),
                      ],
                      if (dataDesignacao != null) ...[
                        const SizedBox(height: 6),
                        _InfoRow(
                          icon: Icons.schedule_outlined,
                          label: 'Aberto em',
                          value: dataFmt.format(dataDesignacao),
                        ),
                      ],
                      if (dataValidade != null) ...[
                        const SizedBox(height: 6),
                        _InfoRow(
                          icon: Icons.event_outlined,
                          label: 'Vence em',
                          value: dataFmt.format(dataValidade),
                          highlight: _venceHoje(dataValidade),
                        ),
                      ],
                      if (chamado.totalCampos > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  minHeight: 6,
                                  value: progresso.clamp(0.0, 1.0),
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    PostoAppUiConfigurations.blueMediumColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${chamado.camposRespondidos}/${chamado.totalCampos}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: PostoAppUiConfigurations.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _venceHoje(DateTime data) {
    final now = DateTime.now();
    return data.year == now.year &&
        data.month == now.month &&
        data.day == now.day;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight
        ? PostoAppUiConfigurations.orangeColor
        : PostoAppUiConfigurations.greyColor;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: PostoAppUiConfigurations.greyColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight
                  ? PostoAppUiConfigurations.orangeColor
                  : PostoAppUiConfigurations.textDarkColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  ({Color bg, Color fg}) get _colors {
    final s = status.toLowerCase();
    if (s.contains('andamento')) {
      return (bg: const Color(0xFFFFF4E5), fg: const Color(0xFFB45309));
    }
    if (s.contains('finaliz') || s.contains('conclu')) {
      return (bg: const Color(0xFFE6F4EA), fg: const Color(0xFF1B873F));
    }
    if (s.contains('cancel') || s.contains('expir')) {
      return (bg: const Color(0xFFFEE2E2), fg: const Color(0xFFB91C1C));
    }
    return (
      bg: PostoAppUiConfigurations.lightPurpleColor,
      fg: PostoAppUiConfigurations.blueMediumColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c.fg,
        ),
      ),
    );
  }
}
