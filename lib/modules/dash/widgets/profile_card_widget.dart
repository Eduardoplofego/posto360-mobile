import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/extra/point_widget.dart';
import 'package:posto360/modules/dash/dash_controller.dart';

class ProfileCardWidget extends GetView<DashController> {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: Image.network(
                      controller.photoUrl,
                      cacheHeight: 60,
                      cacheWidth: 60,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade200,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PointWidget(),
                        const SizedBox(width: 6),
                        Obx(() {
                          return SizedBox(
                            width: constraints.maxWidth - 94,
                            child: Text(
                              controller.nameUser,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                color: PostoAppUiConfigurations.textDarkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    Obx(() {
                      return Text(
                        controller.autheticatedUser.tipoUsuario,
                        style: TextStyle(
                          fontSize: 16,
                          color: PostoAppUiConfigurations.darkGreyColor,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
