import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar({super.key, this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.blueMediumColor,
        image: DecorationImage(
          image: AssetImage('assets/images/waves.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
                title != null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  leading ?? SizedBox.shrink(),
                  title != null
                      ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          title!,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                      : const SizedBox.shrink(),
                ],
              ),
              Spacer(),
              ...actions!,
            ],
          ),
        ],
      ),
    );
  }
}
