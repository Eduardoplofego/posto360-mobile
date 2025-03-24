import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/modules/campanhas/campanhas_controller.dart';

class CardTotalBonusWidget extends GetView<CampanhasController> {
  const CardTotalBonusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.blueMediumColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/waves_card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/coin_icon.png', height: 67),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor da bonificação\napós meta batida',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Obx(() {
                  if (controller.isLoading) {
                    return CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      padding: EdgeInsets.symmetric(vertical: 2),
                    );
                  } else {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'R\$ ',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AnimatedDigitWidget(
                          value: controller.valueTotalBonus,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          // prefix: 'R\$',
                          fractionDigits: 2,
                          enableSeparator: true,
                          decimalSeparator: ',',
                          separateSymbol: '.',
                        ),
                      ],
                    );
                  }
                }),
                Obx(() {
                  return Text(
                    'Prazo: ${DataFormatters.formatarPeriodo(controller.periodSelected)}',
                    maxLines: 2,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
