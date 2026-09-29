import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> abrirDocumentoDoCurso(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);

  var aberto = false;
  if (uri != null) {
    try {
      aberto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, s) {
      log('Erro ao abrir documento do curso: $url', error: e, stackTrace: s);
    }
  }

  if (!aberto && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o documento')));
  }
}

/// Indica que a conclusão do curso está vencida ou perto de vencer (ex: NR20,
/// que precisa ser refeita periodicamente). Não aparece para cursos sem
/// validade de conclusão configurada.
class CursoValidadeConclusaoBadge extends StatelessWidget {
  final CursoValidadeConclusaoModel validade;

  const CursoValidadeConclusaoBadge({super.key, required this.validade});

  @override
  Widget build(BuildContext context) {
    if (!validade.vencido && !validade.venceEmBreve) {
      return const SizedBox.shrink();
    }

    final cor = validade.vencido ? Colors.red.shade700 : PostoAppUiConfigurations.orangeColor;
    final texto =
        validade.vencido ? 'Conclusão vencida' : 'Conclusão vence em breve';
    final dataVencimento = validade.dataVencimento;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: cor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              dataVencimento != null
                  ? '$texto: ${DataFormatters.formatarData(dataVencimento)}'
                  : texto,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Atalho para abrir o certificado do curso, quando emitido pelo backend.
/// Nenhuma ação do app gera o documento: ele já existe assim que o
/// colaborador termina o curso.
class CursoCertificadoResumo extends StatelessWidget {
  final CursoDocumentoModel certificado;

  const CursoCertificadoResumo({super.key, required this.certificado});

  @override
  Widget build(BuildContext context) {
    if (!certificado.emitido || certificado.url == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: Get.width,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _DocumentoChip(
            icone: Icons.workspace_premium_outlined,
            texto: 'Certificado',
            url: certificado.url!,
          ),
        ],
      ),
    );
  }
}

class _DocumentoChip extends StatelessWidget {
  final IconData icone;
  final String texto;
  final String url;

  const _DocumentoChip({
    required this.icone,
    required this.texto,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => abrirDocumentoDoCurso(context, url),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightPurpleColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 16, color: PostoAppUiConfigurations.blueMediumColor),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
