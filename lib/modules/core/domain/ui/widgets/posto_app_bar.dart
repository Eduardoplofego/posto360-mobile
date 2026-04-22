import 'package:flutter/material.dart';

class PostoAppBar extends StatelessWidget {
  final String? title;
  final Widget leading;
  final List<Widget>? actions;
  final Widget? bottomAppbar;
  const PostoAppBar({
    super.key,
    this.title,
    required this.leading,
    this.actions,
    this.bottomAppbar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 145,
          decoration: BoxDecoration(
            color: Color(0xFF2051E5),
            image: DecorationImage(
              image: AssetImage('assets/images/waves.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment:
                bottomAppbar != null
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        leading,
                        title != null
                            ? Text(
                              title!,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    actions != null
                        ? Row(children: [...actions!])
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              bottomAppbar ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
