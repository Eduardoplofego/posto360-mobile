import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/avaliacoes/widgets/user_card.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class SelectUsersPage extends StatelessWidget {
  final List<UserAvaliationModel> users;
  const SelectUsersPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          title: Text(
            'Selecionar avaliado',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Get.back(closeOverlays: true);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/waves.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          backgroundColor: PostoAppUiConfigurations.blueMediumColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromWidth(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 70),
                    Text(
                      'Avaliação de segurança',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300,
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = users[index];
              return GestureDetector(
                onTap: () {
                  Get.back(result: item);
                },
                child: UserCard(model: item),
              );
            },
          ),
        ),
      ),
    );
  }
}
