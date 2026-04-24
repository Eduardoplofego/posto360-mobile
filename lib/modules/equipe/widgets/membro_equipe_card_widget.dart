import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';

class MembroEquipeCardWidget extends StatelessWidget {
  final MembroEquipeModel membro;
  final VoidCallback? onPressed;

  const MembroEquipeCardWidget({
    super.key,
    required this.membro,
    this.onPressed,
  });

  Color _notaColor() {
    if (membro.nota >= 8) return Colors.green.shade700;
    if (membro.nota >= 6) return PostoAppUiConfigurations.orangeColor;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
                child: Text(
                  (membro.nome.isNotEmpty ? membro.nome[0] : '?').toUpperCase(),
                  style: TextStyle(
                    color: PostoAppUiConfigurations.blueMediumColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      membro.nome,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      UtilBrasilFields.obterReal(membro.bonificacaoTotal),
                      style: TextStyle(
                        fontSize: 12,
                        color: PostoAppUiConfigurations.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _notaColor().withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  membro.nota.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _notaColor(),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: PostoAppUiConfigurations.greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
