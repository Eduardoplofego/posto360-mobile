import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MessageMixin on GetxController {
  void messageListener(Rxn<MessagesModel> message) {
    ever<MessagesModel?>(message, (model) {
      if (model != null) {
        Get.snackbar(
          model.title,
          model.message,
          messageText: Text(
            model.message,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: model.type.color(),
          colorText: model.type.textColor(),
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
        return Colors.red.shade400;
      case MessageType.info:
        return Colors.blue.shade400;
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
