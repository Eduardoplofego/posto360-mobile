import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';

class VideoPlayerWidget extends GetView<AulasController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(flickManager: controller.flickManager);
  }
}
