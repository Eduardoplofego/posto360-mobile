import 'package:flutter/material.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/upload_photo_dto.dart';
import 'package:posto360/modules/chamados/widgets/editar_photo_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class EditarCampoCardWidget extends StatelessWidget {
  final ChamadoCampoModel campo;
  final String? valorAtual;
  final bool pendente;
  final ValueChanged<String?> onChanged;
  final List<UploadPhotoDto> uploads;
  final bool Function(String url) isFotoMarcada;
  final void Function(String url) onToggleExclusaoFoto;
  final void Function(UploadPhotoDto foto) onAdicionarUpload;
  final void Function(int index) onRemoverUpload;

  const EditarCampoCardWidget({
    super.key,
    required this.campo,
    required this.valorAtual,
    required this.onChanged,
    required this.uploads,
    required this.isFotoMarcada,
    required this.onToggleExclusaoFoto,
    required this.onAdicionarUpload,
    required this.onRemoverUpload,
    this.pendente = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
        border: pendente
            ? Border.all(color: const Color(0xFFB91C1C), width: 1.5)
            : null,
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
        return _EditarTextField(
          valor: valorAtual,
          placeholder: campo.placeholder,
          onChanged: onChanged,
        );
      case ChamadoCampoTipo.number:
        return _EditarTextField(
          valor: valorAtual,
          placeholder: campo.placeholder ?? '0',
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
        );
      case ChamadoCampoTipo.boolean:
        return _EditarBool(
          valor: valorAtual,
          onChanged: onChanged,
        );
      case ChamadoCampoTipo.select:
        return _EditarSelect(
          opcoes: campo.opcoes,
          valor: valorAtual,
          onChanged: onChanged,
        );
      case ChamadoCampoTipo.photo:
        return EditarPhotoWidget(
          campo: campo,
          uploads: uploads,
          isFotoMarcada: isFotoMarcada,
          onToggleExclusao: onToggleExclusaoFoto,
          onAdicionarUpload: onAdicionarUpload,
          onRemoverUpload: onRemoverUpload,
        );
      case ChamadoCampoTipo.unknown:
        return _ReadOnlyHint(label: 'Tipo "${campo.tipoRaw}" não suportado');
    }
  }
}

class _EditarTextField extends StatefulWidget {
  final String? valor;
  final String? placeholder;
  final ValueChanged<String?> onChanged;
  final TextInputType? keyboardType;

  const _EditarTextField({
    required this.valor,
    required this.placeholder,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  State<_EditarTextField> createState() => _EditarTextFieldState();
}

class _EditarTextFieldState extends State<_EditarTextField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.valor ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType: widget.keyboardType,
      onChanged: (v) => widget.onChanged(v.isEmpty ? null : v),
      style: TextStyle(
        fontSize: 14,
        color: PostoAppUiConfigurations.textDarkColor,
      ),
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Digite a resposta',
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: PostoAppUiConfigurations.blueMediumColor,
          ),
        ),
      ),
    );
  }
}

class _EditarSelect extends StatelessWidget {
  final List<String> opcoes;
  final String? valor;
  final ValueChanged<String?> onChanged;

  const _EditarSelect({
    required this.opcoes,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (opcoes.isEmpty) {
      return _ReadOnlyHint(label: 'Nenhuma opção disponível');
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: opcoes.map((op) {
        final selected = op == valor;
        return InkWell(
          onTap: () => onChanged(op),
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? PostoAppUiConfigurations.blueMediumColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: selected
                    ? PostoAppUiConfigurations.blueMediumColor
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check_rounded : Icons.circle_outlined,
                  size: 14,
                  color: selected
                      ? Colors.white
                      : PostoAppUiConfigurations.darkGreyColor,
                ),
                const SizedBox(width: 6),
                Text(
                  op,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EditarBool extends StatelessWidget {
  final String? valor;
  final ValueChanged<String?> onChanged;

  const _EditarBool({required this.valor, required this.onChanged});

  bool? get _bool {
    final v = valor?.toLowerCase().trim();
    if (v == null || v.isEmpty) return null;
    if (v == 'sim' || v == 'true' || v == '1') return true;
    if (v == 'não' || v == 'nao' || v == 'false' || v == '0') return false;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final atual = _bool;
    return Row(
      children: [
        Expanded(
          child: _BoolChip(
            label: 'Sim',
            icon: Icons.check_rounded,
            selected: atual == true,
            onTap: () => onChanged('sim'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _BoolChip(
            label: 'Não',
            icon: Icons.close_rounded,
            selected: atual == false,
            onTap: () => onChanged('não'),
          ),
        ),
      ],
    );
  }
}

class _BoolChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _BoolChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? PostoAppUiConfigurations.blueMediumColor
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? PostoAppUiConfigurations.blueMediumColor
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? Colors.white
                  : PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : PostoAppUiConfigurations.textDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyHint extends StatelessWidget {
  final String label;

  const _ReadOnlyHint({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: PostoAppUiConfigurations.darkGreyColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
          ),
        ],
      ),
    );
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
