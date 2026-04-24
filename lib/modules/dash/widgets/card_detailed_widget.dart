import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardDetailedWidget extends StatelessWidget {
  final IconData icon;
  final int totalNumber;
  final String title;
  final int totalNumberDetailed;
  final double penalidade;
  final String totalNumberDetailedText;
  final String totalTakeNumberDetailedText;
  final VoidCallback? onPressed;
  final bool hideNumberDetailed;
  final bool hideTrendingDetail;
  final bool trendingUp;

  const CardDetailedWidget({
    super.key,
    required this.icon,
    required this.totalNumber,
    required this.title,
    required this.penalidade,
    required this.totalNumberDetailed,
    required this.totalNumberDetailedText,
    required this.totalTakeNumberDetailedText,
    this.hideNumberDetailed = false,
    this.onPressed,
    this.hideTrendingDetail = false,
    this.trendingUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasButton = onPressed != null;
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(16, 12, hasButton ? 0 : 16, hasButton ? 0 : 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: hasButton ? 16 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: PostoAppUiConfigurations.blueMediumColor,
                        size: 30,
                      ),
                    ),
                    Text(
                      totalNumber.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 7,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: PostoAppUiConfigurations.textDarkColor,
                      ),
                    ),
                    if (!hideTrendingDetail)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: !trendingUp
                              ? const Color.fromARGB(255, 195, 153, 153)
                              : const Color(0xFF97CE71),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          !trendingUp
                              ? Icons.trending_down_outlined
                              : Icons.trending_up_outlined,
                          size: 12,
                          color: !trendingUp
                              ? const Color(0xFF900C0C)
                              : const Color(0xFF43900C),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _BulletItem(
                  color: Colors.blue,
                  label:
                      '${!hideNumberDetailed ? totalNumberDetailed : ''} $totalNumberDetailedText',
                ),
                const SizedBox(height: 6),
                _BulletItem(
                  color: Colors.orange,
                  label:
                      '${!hideNumberDetailed ? totalNumber : ''} $totalTakeNumberDetailedText',
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 10),
                _PenalidadeRow(valor: penalidade),
              ],
            ),
          ),
          if (hasButton) ...[
            const SizedBox(height: 12),
            ButtonCardWidget(onPressed: onPressed!),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final Color color;
  final String label;

  const _BulletItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _PenalidadeRow extends StatelessWidget {
  final double valor;

  const _PenalidadeRow({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Penalidade',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          valor.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valor < 0
                ? Colors.red.shade700
                : PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ],
    );
  }
}
