import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MessageMixin on GetxController {
  void messageListener(Rxn<MessagesModel> message) {
    ever<MessagesModel?>(message, (model) {
      if (model != null) {
        Get.snackbar(
          model.title,
          model.message,
          backgroundColor: model.type.color(),
          colorText: model.type.textColor(),
          snackStyle: SnackStyle.FLOATING,
        );
      }
    });
  }
}

class MessagesModel {
  final String title;
  final String message;
  final MessageType type;

  MessagesModel({
    required this.title,
    required this.message,
    required this.type,
  });
}

enum MessageType { error, info }

extension MessageTypeColorExt on MessageType {
  Color color() {
    switch (this) {
      case MessageType.error:
        return Colors.red.shade300;
      case MessageType.info:
        return Colors.blue[400]!;
    }
  }

  Color textColor() {
    switch (this) {
      case MessageType.error:
        return Colors.black;
      case MessageType.info:
        return Colors.white;
    }
  }
}
