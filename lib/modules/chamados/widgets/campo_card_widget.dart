import 'package:flutter/material.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/widgets/campo_photo_widget.dart';
import 'package:posto360/modules/chamados/widgets/campo_select_widget.dart';
import 'package:posto360/modules/chamados/widgets/campo_text_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CampoCardWidget extends StatelessWidget {
  final ChamadoCampoModel campo;

  const CampoCardWidget({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TipoIcon(tipo: campo.tipo),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  campo.descricao,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
              ),
              if (campo.obrigatorio)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'OBRIGATÓRIO',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB91C1C),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (campo.tipo) {
      case ChamadoCampoTipo.text:
      case ChamadoCampoTipo.number:
        return CampoTextWidget(campo: campo);
      case ChamadoCampoTipo.boolean:
        return _CampoBoolReadOnly(campo: campo);
      case ChamadoCampoTipo.select:
        return CampoSelectWidget(campo: campo);
      case ChamadoCampoTipo.photo:
        return CampoPhotoWidget(campo: campo);
      case ChamadoCampoTipo.unknown:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            'Tipo "${campo.tipoRaw}" não suportado',
            style: TextStyle(
              fontSize: 12,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
          ),
        );
    }
  }
}

class _TipoIcon extends StatelessWidget {
  final ChamadoCampoTipo tipo;

  const _TipoIcon({required this.tipo});

  IconData get _icon {
    switch (tipo) {
      case ChamadoCampoTipo.text:
        return Icons.text_fields_rounded;
      case ChamadoCampoTipo.number:
        return Icons.tag_rounded;
      case ChamadoCampoTipo.boolean:
        return Icons.toggle_on_outlined;
      case ChamadoCampoTipo.select:
        return Icons.checklist_rounded;
      case ChamadoCampoTipo.photo:
        return Icons.image_outlined;
      case ChamadoCampoTipo.unknown:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _icon,
        size: 16,
        color: PostoAppUiConfigurations.blueMediumColor,
      ),
    );
  }
}

class _CampoBoolReadOnly extends StatelessWidget {
  final ChamadoCampoModel campo;

  const _CampoBoolReadOnly({required this.campo});

  @override
  Widget build(BuildContext context) {
    final v = (campo.valorTexto ?? '').toLowerCase().trim();
    final bool? atual = (v == 'true' || v == '1' || v == 'sim')
        ? true
        : (v == 'false' || v == '0' || v == 'não' || v == 'nao')
        ? false
        : null;

    if (atual == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          'Sem resposta',
          style: TextStyle(
            fontSize: 14,
            color: PostoAppUiConfigurations.darkGreyColor,
          ),
        ),
      );
    }

    final color = atual
        ? const Color(0xFF1B873F)
        : const Color(0xFFB91C1C);
    final bg = atual
        ? const Color(0xFFE6F4EA)
        : const Color(0xFFFEE2E2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            atual ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            atual ? 'Sim' : 'Não',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
