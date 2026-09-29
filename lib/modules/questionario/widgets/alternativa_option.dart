import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

/// Espelha o `OptionCardWidget` do checklist, adaptado para uma alternativa
/// de múltipla escolha (uma selecionável por vez) que pode ficar travada
/// (acertada em rodada anterior) ou destacada como a escolha errada anterior.
///
/// O indicador de seleção é um ícone simples (não o widget Radio do
/// Flutter) para que o único alvo de toque seja o InkWell do card inteiro.
class AlternativaOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLocked;
  final bool isWrongPick;
  final VoidCallback? onPressed;

  const AlternativaOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isLocked,
    required this.isWrongPick,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final corSelecao =
        isWrongPick ? Colors.red.shade400 : PostoAppUiConfigurations.blueMediumColor;

    return InkWell(
      onTap: isLocked ? null : onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isWrongPick ? Colors.red.shade300 : Colors.grey,
          ),
          color: isLocked ? Colors.grey.shade100 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? corSelecao : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  decoration: isWrongPick ? TextDecoration.lineThrough : null,
                  color: isWrongPick ? Colors.red.shade400 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
