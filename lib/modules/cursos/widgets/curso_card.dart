import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/widgets/curso_folder_widget.dart';
import 'package:posto360/modules/cursos/widgets/curso_progress_widget.dart';

class CursoCard extends StatelessWidget {
  final CursoModel curso;
  final VoidCallback afterReturnClass;
  final Function(String) showMessageError;
  final Future<bool> Function({required int cursoId}) onStartCourse;
  const CursoCard({
    super.key,
    required this.curso,
    required this.afterReturnClass,
    required this.onStartCourse,
    required this.showMessageError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEAEAEA)),
      ),
      child: Column(
        children: [
          CursoFolderWidget(
            curso: curso,
            afterReturnClass: afterReturnClass,
            onStartCourse: onStartCourse,
            showMessageError: showMessageError,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: Get.width,
            child: Text(
              curso.titulo,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: Text(
              curso.descricao,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CursoProgressWidget(
            totalAulas: curso.totalAulas,
            aulasFinalizadas: curso.aulasConcluidas,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Inscrito em: ${DataFormatters.formatarData(curso.inscricao)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: PostoAppUiConfigurations.greyColor,
                  ),
                ),
              ),
              curso.ultimoAcesso != null && curso.ultimoAcesso!.year != 1900
                  ? Flexible(
                    child: Text(
                      'Acessado em ${DataFormatters.formatarData(curso.ultimoAcesso!)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: PostoAppUiConfigurations.greyColor,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
