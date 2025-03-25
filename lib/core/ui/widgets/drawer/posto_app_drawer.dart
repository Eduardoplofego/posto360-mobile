import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/models/user_model.dart';

class PostoAppDrawer extends StatelessWidget {
  final UserModel autheticatedUser;
  const PostoAppDrawer({super.key, required this.autheticatedUser});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: Drawer(
            width: Get.width * .7,
            backgroundColor: Colors.white,
            child: SizedBox(
              height: constraints.maxHeight,
              child: Column(
                children: [_profileCard(autheticatedUser), Spacer(), _logout()],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _logout() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              Get.find<AuthService>().logout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white),
                const SizedBox(width: 6),
                Text('Logout', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _profileCard(UserModel user) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.blueMediumColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white38,
            child: CircleAvatar(
              radius: 43,
              backgroundImage:
                  user.photoUrl != null && user.photoUrl != ''
                      ? NetworkImage(user.photoUrl!)
                      : null,
              child:
                  user.photoUrl != null && user.photoUrl != ''
                      ? const SizedBox.shrink()
                      : Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${user.name} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            autheticatedUser.tipoUsuario,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
