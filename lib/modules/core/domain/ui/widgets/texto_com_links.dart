import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Texto comum que transforma URLs escritas no meio do conteúdo em links.
///
/// Os procedimentos são digitados no administrativo como texto puro: quem
/// escreve cola o endereço no meio da frase, sem marcação nenhuma. Este widget
/// acha esses endereços e abre no navegador ao toque, mantendo o resto do
/// texto exatamente como veio.
class TextoComLinks extends StatefulWidget {
  final String texto;
  final TextStyle? style;

  /// Cor do link. O padrão contrasta com fundo claro; em fundo escuro
  /// (o cabeçalho azul do procedimento, por exemplo) passe uma cor clara.
  final Color? linkColor;

  final int? maxLines;
  final TextOverflow? overflow;

  const TextoComLinks({
    super.key,
    required this.texto,
    this.style,
    this.linkColor,
    this.maxLines,
    this.overflow,
  });

  @override
  State<TextoComLinks> createState() => _TextoComLinksState();
}

class _TextoComLinksState extends State<TextoComLinks> {
  static final _regexUrl = RegExp(
    r'(https?://|www\.)[^\s<>"]+',
    caseSensitive: false,
  );

  /// Pontuação colada no fim do endereço quase sempre pertence à frase, não ao
  /// link: "veja em https://x.com/y." não deve levar o ponto junto.
  static const _pontuacaoFinal = '.,;:!?)]}\'"';

  List<_ParteTexto> _partes = const [];
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void initState() {
    super.initState();
    _processar();
  }

  @override
  void didUpdateWidget(TextoComLinks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.texto != widget.texto) _processar();
  }

  @override
  void dispose() {
    _descartarRecognizers();
    super.dispose();
  }

  void _descartarRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  void _processar() {
    _descartarRecognizers();
    _partes = _dividirEmPartes(widget.texto);
    for (final parte in _partes) {
      final url = parte.url;
      if (url == null) continue;
      _recognizers.add(TapGestureRecognizer()..onTap = () => _abrir(url));
    }
  }

  static List<_ParteTexto> _dividirEmPartes(String texto) {
    final partes = <_ParteTexto>[];
    var cursor = 0;

    for (final match in _regexUrl.allMatches(texto)) {
      var url = match.group(0)!;
      var fim = match.end;

      while (url.isNotEmpty && _pontuacaoFinal.contains(url[url.length - 1])) {
        url = url.substring(0, url.length - 1);
        fim--;
      }
      if (url.isEmpty) continue;

      if (match.start > cursor) {
        partes.add(_ParteTexto(texto.substring(cursor, match.start), null));
      }
      partes.add(_ParteTexto(url, url));
      cursor = fim;
    }

    if (cursor < texto.length) {
      partes.add(_ParteTexto(texto.substring(cursor), null));
    }
    return partes;
  }

  Future<void> _abrir(String url) async {
    // quem escreve costuma colar "www.algo.com" sem o protocolo
    final endereco = url.startsWith('http') ? url : 'https://$url';
    final uri = Uri.tryParse(endereco);

    var aberto = false;
    if (uri != null) {
      try {
        aberto = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e, s) {
        log(
          'Erro ao abrir link do procedimento: $url',
          error: e,
          stackTrace: s,
        );
      }
    }

    if (!aberto && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final temLink = _partes.any((parte) => parte.url != null);
    if (!temLink) {
      return Text(
        widget.texto,
        style: widget.style,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    final corLink =
        widget.linkColor ?? PostoAppUiConfigurations.blueMediumColor;
    final spans = <TextSpan>[];
    var indiceLink = 0;

    for (final parte in _partes) {
      if (parte.url == null) {
        spans.add(TextSpan(text: parte.texto));
        continue;
      }
      spans.add(
        TextSpan(
          text: parte.texto,
          style: TextStyle(
            color: corLink,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: corLink,
          ),
          recognizer: _recognizers[indiceLink++],
        ),
      );
    }

    return Text.rich(
      TextSpan(style: widget.style, children: spans),
      maxLines: widget.maxLines,
      overflow: widget.overflow ?? TextOverflow.clip,
    );
  }
}

class _ParteTexto {
  final String texto;

  /// `null` em trechos comuns; preenchido quando o trecho é um endereço.
  final String? url;

  const _ParteTexto(this.texto, this.url);
}
