import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class TemplateCardWidget extends StatelessWidget {
  final ChamadoTemplateModel template;
  final VoidCallback onPressed;

  const TemplateCardWidget({
    super.key,
    required this.template,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = template.color;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    template.nome,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: PostoAppUiConfigurations.textDarkColor,
                      height: 1.2,
                    ),
                  ),
                  if (template.descricao.trim().isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      template.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
