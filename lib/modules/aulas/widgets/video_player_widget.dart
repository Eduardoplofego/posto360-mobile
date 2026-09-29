import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';
import 'package:posto360/modules/aulas/widgets/pdf_viewer_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends GetView<AulasController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isToShowMaterial) {
        return PdfViewerWidget();
      } else if (controller.videoInitialized) {
        return Container(
          color: Colors.black,
          width: Get.width,
          height: Get.height * .315,
          // key novo a cada troca de aula: forca o widget (e o player do
          // YouTube por baixo) a ser desmontado e remontado do zero, senao o
          // video da aula anterior continua tocando ao trocar de aula
          child: YoutubePlayer(
            key: ValueKey('youtube-player-${controller.currentAula?.id}'),
            controller: controller.youtubeController!,
            showVideoProgressIndicator: true,
          ),
        );
      } else {
        return Container(
          width: Get.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black,
            image:
                controller.currentAula?.capa != null &&
                        controller.currentAula!.capa != ''
                    ? DecorationImage(
                      image: NetworkImage(controller.currentAula!.capa),
                    )
                    : null,
          ),
          child: Center(
            child: Text(
              controller.isLoading
                  ? 'Carregando video...'
                  : 'Video não encontrado!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      }
    });
  }
}
