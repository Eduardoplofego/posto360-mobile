import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/extra/point_widget.dart';

class ProfileCardAppBar extends StatelessWidget {
  const ProfileCardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: PostoAppUiConfigurations.greyColor,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg',
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    PointWidget(),
                    Text(
                      'Fernando Sampaio',
                      style: TextStyle(
                        fontSize: 18,
                        color: PostoAppUiConfigurations.textDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: 16,
                    color: PostoAppUiConfigurations.darkGreyColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
