import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/extra/point_widget.dart';
import 'package:posto360/modules/dash/dash_controller.dart';

class ProfileCardWidget extends GetView<DashController> {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: PostoAppUiConfigurations.greyColor,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          controller.hasPhotoUrl
                              ? NetworkImage(
                                controller.autheticatedUser.photoUrl!,
                              )
                              : null,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade400,
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
        );
      },
    );
  }
}
