import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class EmptyDashboardModelWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  const EmptyDashboardModelWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              'Não foi possível obter sua performance ou você não tem dados para esse período',
            ),
            SizedBox(
              width: 200,
              child: TextButton(
                onPressed: onRefresh,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: PostoAppUiConfigurations.blueMediumColor,
                    ),
                    Text(
                      'Recarregue',
                      style: TextStyle(
                        color: PostoAppUiConfigurations.blueMediumColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
