import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardCampanhasWidget extends StatelessWidget {
  final int campanhasAtivas;
  final double bonificacaoTotal;
  final VoidCallback? onPressed;

  const CardCampanhasWidget({
    super.key,
    required this.onPressed,
    required this.campanhasAtivas,
    required this.bonificacaoTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: 10,
        right: onPressed != null ? 0 : 16,
        left: 16,
        bottom: onPressed != null ? 0 : 20,
      ),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.speed_outlined,
                            color: PostoAppUiConfigurations.blueMediumColor,
                            size: 30,
                          ),
                        ),
                        Text(
                          campanhasAtivas.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            'Performance Campanhas',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UtilBrasilFields.obterReal(bonificacaoTotal),
                      style: TextStyle(
                        fontSize: 20,
                        color: PostoAppUiConfigurations.blueMediumColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPressed != null
              ? ButtonCardWidget(onPressed: onPressed!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
