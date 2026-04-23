import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardProcedimentosWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const CardProcedimentosWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: 16,
        right: onPressed != null ? 0 : 16,
        left: 16,
        bottom: onPressed != null ? 0 : 20,
      ),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: PostoAppUiConfigurations.blueMediumColor,
                  size: 28,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Procedimentos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: PostoAppUiConfigurations.textDarkColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manuais operacionais e boas práticas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                _ChipInfo(
                  icon: Icons.local_gas_station_outlined,
                  label: 'Pista de abastecimento',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          onPressed != null
              ? ButtonCardWidget(onPressed: onPressed!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChipInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(
            icon,
            size: 14,
            color: PostoAppUiConfigurations.blueMediumColor,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: PostoAppUiConfigurations.textDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}
