import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/procedimentos/domain/models/passo_model.dart';

class PassoItemWidget extends StatelessWidget {
  final PassoModel passo;

  const PassoItemWidget({super.key, required this.passo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: PostoAppUiConfigurations.blueMediumColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${passo.ordem}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              passo.descricao,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
