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
                        Flexible(
                          child: Text(
                            'Performance campanhas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                        Text(
                          '$campanhasAtivas campanha${campanhasAtivas > 1 ? 's' : ''} ativa${campanhasAtivas > 1 ? 's' : ''}',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                        Text(
                          'Bonificação total: ${UtilBrasilFields.obterReal(bonificacaoTotal)}',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
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
