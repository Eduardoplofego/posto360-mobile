import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/cursos/widgets/curso_folder_widget.dart';
import 'package:posto360/modules/cursos/widgets/curso_progress_widget.dart';

class CursoCard extends StatelessWidget {
  final CursoModel curso;
  const CursoCard({super.key, required this.curso});

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
          CursoFolderWidget(folder: curso.capa),
          const SizedBox(height: 12),
          SizedBox(
            width: Get.width,
            child: Text(
              curso.titulo,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: PostoAppUiConfigurations.blueLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${curso.aulasConcluidas} aulas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                Text(
                  'Duração média ${curso.getDuracaoMedia()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
          const SizedBox(height: 12),
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
                  'Inscrito em ${curso.inscricao}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: PostoAppUiConfigurations.greyColor,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Acessado em ${curso.ultimoAcesso}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: PostoAppUiConfigurations.greyColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
