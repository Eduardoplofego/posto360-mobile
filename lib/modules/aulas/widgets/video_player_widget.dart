import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';

class VideoPlayerWidget extends GetView<AulasController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.videoInitialized) {
        return FlickVideoPlayer(flickManager: controller.flickManager!);
      } else {
        return Container(
          width: Get.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black,
            image:
                controller.currentAula != null
                    ? DecorationImage(
                      image: NetworkImage(controller.currentAula!.capa),
                    )
                    : null,
          ),
          child: Center(
            child: Text(
              'Video não encontrado!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      }
    });
  }
}
