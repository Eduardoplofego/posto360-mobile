import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MessageMixin on GetxController {
  void messageListener(Rxn<MessagesModel> message) {
    ever<MessagesModel?>(message, (model) {
      if (model == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = Get.context;
        if (ctx == null) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              model.message,
              style: TextStyle(color: model.type.textColor()),
            ),
            backgroundColor: model.type.color(),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      });
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
