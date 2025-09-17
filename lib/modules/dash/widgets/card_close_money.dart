import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardCloseMoney extends StatelessWidget {
  final int cardsDeleted;
  final int cardsLinked;
  final int cardsCorrected;
  final int cardsInserted;
  final VoidCallback onPressed;
  const CardCloseMoney({
    super.key,
    required this.cardsDeleted,
    required this.cardsLinked,
    required this.cardsCorrected,
    required this.cardsInserted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 10, right: 0, left: 16, bottom: 0),
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
                            Icons.account_balance_wallet_outlined,
                            color: PostoAppUiConfigurations.blueMediumColor,
                            size: 30,
                          ),
                        ),
                        Text(
                          'Fechamento caixa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 12),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.blue,
                                  ),
                                  Text(
                                    // '${!hideNumberDetailed ? totalNumberDetailed : ''} $totalNumberDetailedText',
                                    'Cartões deletados: $cardsDeleted',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.orange,
                                  ),
                                  Text(
                                    // '${!hideNumberDetailed ? totalNumber : ''} $totalTakeNumberDetailedText',
                                    'Cartões vinculados: $cardsLinked',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.blue,
                                  ),
                                  Text(
                                    // '${!hideNumberDetailed ? totalNumberDetailed : ''} $totalNumberDetailedText',
                                    'Cartões corrigidos: $cardsCorrected',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.orange,
                                  ),
                                  Text(
                                    // '${!hideNumberDetailed ? totalNumber : ''} $totalTakeNumberDetailedText',
                                    'Cartões inseridos: $cardsInserted',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ButtonCardWidget(onPressed: () {}),
        ],
      ),
    );
  }
}
