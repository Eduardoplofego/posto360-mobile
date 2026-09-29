import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/cursos/widgets/curso_documentos_widget.dart';

/// Último item da timeline de aulas, logo abaixo da prova final: mostra o
/// certificado gerado pelo backend quando o curso é concluído (nenhuma ação
/// do app precisa acontecer para ele existir) e, se o curso tiver validade
/// de conclusão (ex: NR20), o aviso de vencido/vence em breve.
///
/// Espelha `TimelineQuizItemWidget`/`TimelineClassItemWidget`, mas só entra
/// na timeline quando há certificado emitido para mostrar.
class TimelineCertificadoItemWidget extends StatelessWidget {
  final CursoDocumentoModel certificado;
  final CursoValidadeConclusaoModel validade;

  const TimelineCertificadoItemWidget({
    super.key,
    required this.certificado,
    required this.validade,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * .85,
                  padding: const EdgeInsets.fromLTRB(16, 33, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 7,
                        spreadRadius: .2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Certificado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PostoAppUiConfigurations.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Curso concluído',
                        style: TextStyle(
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CursoValidadeConclusaoBadge(validade: validade),
                      CursoCertificadoResumo(certificado: certificado),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: PostoAppUiConfigurations.blueLightColor,
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
