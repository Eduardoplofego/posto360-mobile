import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/cartao_discrepancia_model.dart';

class CartaoDiscrepanciaCardWidget extends StatelessWidget {
  final CartaoDiscrepanciaModel cartao;

  const CartaoDiscrepanciaCardWidget({super.key, required this.cartao});

  @override
  Widget build(BuildContext context) {
    final antigo = cartao.antigo;
    final correto = cartao.correto;

    final linhas =
        <_LinhaComparacao>[
          _LinhaComparacao(
            label: 'Autorização',
            antigo: antigo.autorizacao,
            correto: correto.autorizacao,
          ),
          _LinhaComparacao(
            label: 'Bandeira',
            antigo: antigo.bandeira,
            correto: correto.bandeira,
          ),
          _LinhaComparacao(
            label: 'Vencimento',
            antigo: _formatarData(antigo.vencimento),
            correto: _formatarData(correto.vencimento),
          ),
          _LinhaComparacao(
            label: 'Valor',
            antigo: _formatarValor(antigo.valorBruto),
            correto: _formatarValor(correto.valorBruto),
          ),
        ].where((linha) => linha.temConteudo).toList();

    // Deletado e Inserido nao tem o lado da adquirente gravado: uma coluna
    // inteira de tracos nao diz nada, entao ela sai e vira uma nota.
    final temComparacao = cartao.hasCorrecao;
    final linhasExibidas =
        temComparacao
            ? linhas
            : linhas.map((linha) => linha.semColunaCorreta()).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(cartao: cartao),
              Text(
                UtilBrasilFields.obterReal(cartao.valorBruto),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (cartao.tipos.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  cartao.tipos.map((tipo) => _TipoChip(tipo: tipo)).toList(),
            ),
          ],
          if (linhasExibidas.isNotEmpty) ...[
            const Divider(height: 24, color: Color(0xFFECECEC)),
            if (temComparacao) ...[
              const _CabecalhoComparacao(),
              const SizedBox(height: 8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: linhasExibidas,
            ),
            if (!temComparacao) ...[
              const SizedBox(height: 10),
              const _NotaSemComparacao(),
            ],
          ],
        ],
      ),
    );
  }
}

String? _formatarData(DateTime? data) {
  if (data == null) return null;
  return DateFormat('dd/MM/yyyy').format(data);
}

String? _formatarValor(double? valor) {
  if (valor == null) return null;
  return UtilBrasilFields.obterReal(valor);
}

class _CabecalhoComparacao extends StatelessWidget {
  const _CabecalhoComparacao();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: _LinhaComparacao.larguraLabel),
        Expanded(
          child: _ChipCabecalho(
            texto: 'NO PDV',
            cor: Colors.black54,
            fundo: const Color(0xFFF3F4F6),
          ),
        ),
        const SizedBox(width: _LinhaComparacao.espacoColunas),
        Expanded(
          child: _ChipCabecalho(
            texto: 'CORRETO',
            cor: Colors.green.shade800,
            fundo: Colors.green.shade50,
          ),
        ),
      ],
    );
  }
}

class _NotaSemComparacao extends StatelessWidget {
  const _NotaSemComparacao();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 12, color: Colors.black38),
        const SizedBox(width: 4),
        const Expanded(
          child: Text(
            'Sem valores da adquirente registrados para comparar',
            style: TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ),
      ],
    );
  }
}

class _ChipCabecalho extends StatelessWidget {
  final String texto;
  final Color cor;
  final Color fundo;

  const _ChipCabecalho({
    required this.texto,
    required this.cor,
    required this.fundo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: cor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _LinhaComparacao extends StatelessWidget {
  static const larguraLabel = 84.0;
  static const espacoColunas = 10.0;

  final String label;
  final String? antigo;
  final String? correto;
  final bool mostrarColunaCorreta;

  const _LinhaComparacao({
    required this.label,
    required this.antigo,
    required this.correto,
    this.mostrarColunaCorreta = true,
  });

  _LinhaComparacao semColunaCorreta() => _LinhaComparacao(
    label: label,
    antigo: antigo,
    correto: correto,
    mostrarColunaCorreta: false,
  );

  bool get temConteudo => antigo != null || correto != null;

  /// A API so preenche o lado correto em parte dos casos; quando preenche e o
  /// valor difere do PDV, e essa a divergencia que o operador resolveu.
  bool get foiAlterado => correto != null && correto != antigo;

  @override
  Widget build(BuildContext context) {
    const estiloValor = TextStyle(fontSize: 13, color: Colors.black87);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: larguraLabel,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            antigo ?? '—',
            style:
                foiAlterado
                    ? estiloValor.copyWith(
                      color: Colors.black38,
                      decoration: TextDecoration.lineThrough,
                    )
                    : estiloValor,
          ),
        ),
        if (mostrarColunaCorreta) ...[
          const SizedBox(width: espacoColunas),
          Expanded(
            child: Text(
              correto ?? '—',
              style:
                  foiAlterado
                      ? estiloValor.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      )
                      : estiloValor.copyWith(color: Colors.black38),
            ),
          ),
        ],
      ],
    );
  }
}

class _TipoChip extends StatelessWidget {
  final String tipo;

  const _TipoChip({required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 12, color: Colors.orange.shade800),
          const SizedBox(width: 4),
          Text(
            tipo,
            style: TextStyle(fontSize: 11, color: Colors.orange.shade900),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final CartaoDiscrepanciaModel cartao;

  const _StatusBadge({required this.cartao});

  @override
  Widget build(BuildContext context) {
    final cor = cartao.status.cor;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cartao.status.icone, size: 13, color: cor),
          const SizedBox(width: 5),
          Text(
            cartao.statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
        ],
      ),
    );

    if (cartao.status.descricao.isEmpty) return badge;

    return Tooltip(
      message: cartao.status.descricao,
      triggerMode: TooltipTriggerMode.tap,
      child: badge,
    );
  }
}

extension on StatusCartao {
  Color get cor {
    switch (this) {
      case StatusCartao.vinculado:
        return const Color(0xFF1C47C7);
      case StatusCartao.corrigido:
        return Colors.green.shade700;
      case StatusCartao.deletado:
        return Colors.red.shade700;
      case StatusCartao.inserido:
        return Colors.purple.shade700;
      case StatusCartao.desconhecido:
        return Colors.grey.shade600;
    }
  }

  IconData get icone {
    switch (this) {
      case StatusCartao.vinculado:
        return Icons.link;
      case StatusCartao.corrigido:
        return Icons.check_circle_outline;
      case StatusCartao.deletado:
        return Icons.delete_outline;
      case StatusCartao.inserido:
        return Icons.add_circle_outline;
      case StatusCartao.desconhecido:
        return Icons.help_outline;
    }
  }
}
