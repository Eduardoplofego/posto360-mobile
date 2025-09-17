import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class CardLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final double height;
  final double? width;
  final Widget child;
  final int initDelay;
  const CardLoadingWidget({
    super.key,
    required this.isLoading,
    required this.height,
    this.width,
    required this.child,
    this.initDelay = 1,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CardLoading(
          height: height,
          borderRadius: BorderRadius.circular(20),
          animationDuration: Duration(milliseconds: initDelay + 500),
        )
        : child;
  }
}
