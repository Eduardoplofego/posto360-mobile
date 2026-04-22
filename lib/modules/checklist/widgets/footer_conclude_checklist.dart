import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class FooterConcludeChecklist extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  const FooterConcludeChecklist({
    super.key,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isActive ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PostoAppUiConfigurations.blueMediumColor,
                ),
                child: Text(
                  'Finalizar checklist',
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? Colors.white : Colors.black38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
