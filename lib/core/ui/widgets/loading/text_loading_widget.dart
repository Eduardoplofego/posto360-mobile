import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final double height;
  final double? width;
  final Widget child;
  const TextLoadingWidget({
    super.key,
    required this.isLoading,
    required this.height,
    this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CardLoading(
          height: height,
          width: width ?? Get.width,
          borderRadius: BorderRadius.circular(20),
        )
        : child;
  }
}
