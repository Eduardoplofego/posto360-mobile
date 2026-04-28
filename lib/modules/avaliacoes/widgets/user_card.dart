import 'package:flutter/material.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class UserCard extends StatelessWidget {
  final UserAvaliationModel model;
  const UserCard({super.key, required this.model});

  String _initialNames(String name) {
    final nameSplitted = name.split(' ');
    if (nameSplitted.length == 1) {
      return name.substring(0, 1).toUpperCase();
    }
    return '${nameSplitted[0].substring(0, 1).toUpperCase()}${nameSplitted[1].substring(0, 1).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 45,
            height: 45,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  PostoAppUiConfigurations.blueMediumColor,
                  PostoAppUiConfigurations.blueLightColor,
                ],
              ),
            ),
            child: Center(
              child: Text(
                _initialNames(model.name),
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    color: PostoAppUiConfigurations.greyColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  model.funcao,
                  style: TextStyle(
                    color: PostoAppUiConfigurations.darkGreyColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chevron_right_rounded),
            color: PostoAppUiConfigurations.darkGreyColor,
          ),
        ],
      ),
    );
  }
}
