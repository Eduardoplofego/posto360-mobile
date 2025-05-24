import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/checklist/checklist_controller.dart';

class GeneralChecklistWidget extends GetView<ChecklistController> {
  final VoidCallback firstTap;
  final VoidCallback secondTap;
  final bool isFirstSelected;
  final num firstNumber;
  final num secondNumber;
  final String firstText;
  final String secondText;
  const GeneralChecklistWidget({
    super.key,
    required this.firstTap,
    required this.secondTap,
    required this.isFirstSelected,
    required this.firstNumber,
    required this.secondNumber,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: Get.width,
        child: Row(
          children: [
            Spacer(),
            InkWell(
              onTap: firstTap,
              child: Row(
                children: [
                  isFirstSelected
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                            color: PostoAppUiConfigurations.blueMediumColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                  Text(
                    '$firstNumber $firstText',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          isFirstSelected
                              ? PostoAppUiConfigurations.textDarkColor
                              : PostoAppUiConfigurations.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: secondTap,
              child: Row(
                children: [
                  !isFirstSelected
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                            color: PostoAppUiConfigurations.blueMediumColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                  Text(
                    '$secondNumber $secondText',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          !isFirstSelected
                              ? PostoAppUiConfigurations.textDarkColor
                              : PostoAppUiConfigurations.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
