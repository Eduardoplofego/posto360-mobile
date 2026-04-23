import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class PassoImagemWidget extends StatelessWidget {
  final String url;

  const PassoImagemWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              height: 140,
              color: Colors.white,
              alignment: Alignment.center,
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: PostoAppUiConfigurations.blueMediumColor,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stack) {
            return Container(
              height: 100,
              color: Colors.white,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: PostoAppUiConfigurations.darkGreyColor,
                    size: 20,
                  ),
                  Text(
                    'Imagem indisponível',
                    style: TextStyle(
                      fontSize: 12,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
