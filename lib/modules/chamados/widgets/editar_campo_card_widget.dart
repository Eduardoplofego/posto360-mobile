import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_tanque_model.dart';
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
  final Map<String, String> litrosPorTanque;
  final void Function(String tanqueId, String valor) onLitrosTanqueChanged;

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
    required this.litrosPorTanque,
    required this.onLitrosTanqueChanged,
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
      case ChamadoCampoTipo.tanques:
        return _EditarTanques(
          tanques: campo.tanques,
          litrosPorTanque: litrosPorTanque,
          onChanged: onLitrosTanqueChanged,
        );
      case ChamadoCampoTipo.unknown:
        return _ReadOnlyHint(label: 'Tipo "${campo.tipoRaw}" não suportado');
    }
  }
}

class _EditarTanques extends StatefulWidget {
  final List<ChamadoTanqueModel> tanques;
  final Map<String, String> litrosPorTanque;
  final void Function(String tanqueId, String valor) onChanged;

  const _EditarTanques({
    required this.tanques,
    required this.litrosPorTanque,
    required this.onChanged,
  });

  @override
  State<_EditarTanques> createState() => _EditarTanquesState();
}

class _EditarTanquesState extends State<_EditarTanques> {
  final _selecionados = <String>{};

  static final NumberFormat _litrosFormat = NumberFormat.decimalPattern('pt_BR');

  /// So entram no filtro os produtos que a filial realmente tem em tanque.
  List<String> get _codigos {
    final presentes = <String>{
      for (final tanque in widget.tanques) tanque.produtoCodigo,
    };
    return [
      ...ordemCodigosProduto.where(presentes.contains),
      ...presentes.where((c) => !ordemCodigosProduto.contains(c)),
    ];
  }

  int _litros(ChamadoTanqueModel tanque) =>
      int.tryParse((widget.litrosPorTanque[tanque.tanqueId] ?? '').trim()) ?? 0;

  /// Sem filtro, mostra tudo. Com filtro, mostra os produtos marcados e tambem
  /// qualquer tanque ja lancado, para o motorista nao perder de vista o que
  /// digitou ao trocar a selecao.
  List<ChamadoTanqueModel> get _visiveis {
    if (_selecionados.isEmpty) return widget.tanques;
    return widget.tanques
        .where(
          (t) => _selecionados.contains(t.produtoCodigo) || _litros(t) > 0,
        )
        .toList();
  }

  int get _total =>
      widget.tanques.fold<int>(0, (soma, t) => soma + _litros(t));

  void _alternar(String codigo) {
    setState(() {
      if (!_selecionados.remove(codigo)) _selecionados.add(codigo);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tanques.isEmpty) {
      return _ReadOnlyHint(
        label: 'Nenhum tanque cadastrado para esta filial',
      );
    }
    final visiveis = _visiveis;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Marque os produtos que vieram na carga para filtrar os tanques, e '
          'informe os litros descarregados em cada um.',
          style: TextStyle(
            fontSize: 11,
            color: PostoAppUiConfigurations.darkGreyColor,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _codigos
              .map(
                (codigo) => _ChipProduto(
                  label: codigo,
                  selecionado: _selecionados.contains(codigo),
                  onTap: () => _alternar(codigo),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        ...visiveis.map(
          (tanque) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LinhaTanque(
              key: ValueKey(tanque.tanqueId),
              tanque: tanque,
              valor: widget.litrosPorTanque[tanque.tanqueId] ?? '',
              onChanged: (v) {
                widget.onChanged(tanque.tanqueId, v);
                // O total e a visibilidade dependem do que foi digitado.
                setState(() {});
              },
            ),
          ),
        ),
        if (_total > 0) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total descarregado',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.darkGreyColor,
                  ),
                ),
              ),
              Text(
                '${_litrosFormat.format(_total)} L',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PostoAppUiConfigurations.blueMediumColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ChipProduto extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _ChipProduto({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selecionado
              ? PostoAppUiConfigurations.blueMediumColor
              : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selecionado
                ? PostoAppUiConfigurations.blueMediumColor
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selecionado
                ? Colors.white
                : PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ),
    );
  }
}

class _LinhaTanque extends StatefulWidget {
  final ChamadoTanqueModel tanque;
  final String valor;
  final ValueChanged<String> onChanged;

  const _LinhaTanque({
    super.key,
    required this.tanque,
    required this.valor,
    required this.onChanged,
  });

  @override
  State<_LinhaTanque> createState() => _LinhaTanqueState();
}

class _LinhaTanqueState extends State<_LinhaTanque> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.valor);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final capacidade = widget.tanque.capacidade;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tanque.produto,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                Text(
                  capacidade == null
                      ? 'Tanque ${widget.tanque.tanqueId}'
                      : 'Tanque ${widget.tanque.tanqueId} · ${capacidade.round()} L',
                  style: TextStyle(
                    fontSize: 11,
                    color: PostoAppUiConfigurations.darkGreyColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 96,
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                suffixText: 'L',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      case ChamadoCampoTipo.tanques:
        return Icons.local_gas_station_outlined;
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
