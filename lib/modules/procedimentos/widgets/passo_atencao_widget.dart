import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/procedimentos/domain/models/passo_model.dart';
import 'package:posto360/modules/procedimentos/widgets/passo_imagem_widget.dart';

class PassoAtencaoWidget extends StatelessWidget {
  final PassoModel passo;

  const PassoAtencaoWidget({super.key, required this.passo});

  @override
  Widget build(BuildContext context) {
    final orange = PostoAppUiConfigurations.orangeColor;
    final temImagem = (passo.imagem ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EC),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: orange, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: orange,
                size: 20,
              ),
              Expanded(
                child: Text(
                  passo.descricao,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7C3300),
                  ),
                ),
              ),
            ],
          ),
          if (temImagem) ...[
            const SizedBox(height: 10),
            PassoImagemWidget(url: passo.imagem!),
          ],
        ],
      ),
    );
  }
}
