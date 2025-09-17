import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';

class PostoAppDrawer extends StatefulWidget {
  final UserModel autheticatedUser;
  final Future<ResultActionDTO<String>> Function(String) onSavePhoto;
  const PostoAppDrawer({
    super.key,
    required this.autheticatedUser,
    required this.onSavePhoto,
  });

  @override
  State<PostoAppDrawer> createState() => _PostoAppDrawerState();
}

class _PostoAppDrawerState extends State<PostoAppDrawer> {
  Future<void> _onLogout() async {
    final shouldLogout = await _requestLogout();

    if (!shouldLogout) return;

    Get.find<AuthService>().logout();
  }

  Future<bool> _requestLogout() async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Sair'),
        content: Text(
          'Você tem certeza que deseja sair?',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.red.shade400),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Sair',
              style: TextStyle(
                fontSize: 16,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldLogout ?? false;
  }

  Future<void> _takePhotoAndSave() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final result = await widget.onSavePhoto(image.path);
    if (result.isError) {
      Get.snackbar(
        'Erro',
        result.message,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
    GetStorage().write(Constants.USER_PHOTO_URL, result.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: constraints,
            child: Drawer(
              width: Get.width * .7,
              backgroundColor: Colors.white,
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    _profileCard(widget.autheticatedUser),
                    const SizedBox(height: 8),
                    ListTile(
                      onTap: _takePhotoAndSave,
                      title: Text(
                        'Alterar foto de perfil',
                        style: TextStyle(fontSize: 14),
                      ),
                      dense: true,
                      trailing: Icon(
                        Icons.edit,
                        color: PostoAppUiConfigurations.darkGreyColor,
                        size: 20,
                      ),
                    ),
                    Spacer(),
                    _logout(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
            onPressed: _onLogout,
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
    String photoUrl;
    final isToTakeFotoFromStorage =
        GetStorage().read(Constants.USER_PHOTO_URL) != null &&
        GetStorage().read(Constants.USER_PHOTO_URL) != '';
    if (isToTakeFotoFromStorage) {
      photoUrl = GetStorage().read(Constants.USER_PHOTO_URL);
    } else {
      photoUrl = user.photoUrl ?? '';
    }
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PostoAppUiConfigurations.blueLightColor,
            PostoAppUiConfigurations.blueMediumColor,
          ],
          stops: [0.0, 1.0],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          tileMode: TileMode.repeated,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          photoUrl.isNotEmpty
              ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  photoUrl,
                  cacheHeight: 90,
                  cacheWidth: 90,
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
              )
              : CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 60, color: Colors.white24),
              ),
          const SizedBox(height: 10),
          Text(
            '${user.name} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            widget.autheticatedUser.tipoUsuario,
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
