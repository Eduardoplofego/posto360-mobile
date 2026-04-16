import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class TabbarWidget extends StatelessWidget {
  final bool isLeftSelected;
  final VoidCallback onLeftSelected;
  final VoidCallback onRigthSelected;
  const TabbarWidget({
    super.key,
    required this.isLeftSelected,
    required this.onLeftSelected,
    required this.onRigthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 45, 82, 194),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(4),
        width: Get.width,
        height: 50,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onLeftSelected,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (Get.width) / 2,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isLeftSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Avaliado',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:
                                isLeftSelected
                                    ? PostoAppUiConfigurations.blueMediumColor
                                    : Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onRigthSelected,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (Get.width) / 2,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isLeftSelected ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Módulo avaliador',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:
                                isLeftSelected
                                    ? Colors.white60
                                    : PostoAppUiConfigurations.blueMediumColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
