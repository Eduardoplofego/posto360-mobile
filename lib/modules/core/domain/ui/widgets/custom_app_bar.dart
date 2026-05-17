import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget>? actions;
  final bool withRoundedBorders;
  final Widget? bottomAppbar;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.leading,
    this.actions,
    this.withRoundedBorders = true,
    this.bottomAppbar,
    this.height = 70,
  });

  static double get _statusBarHeight {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return 0;
    return view.padding.top / view.devicePixelRatio;
  }

  static Size preferredSizeFor({double height = 70}) =>
      Size.fromHeight(height + _statusBarHeight);

  @override
  Size get preferredSize => Size.fromHeight(height + _statusBarHeight);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
      decoration: BoxDecoration(
        color: Color(0xFF2051E5),
        image: DecorationImage(
          image: AssetImage('assets/images/waves.png'),
          fit: BoxFit.cover,
        ),
        borderRadius:
            withRoundedBorders
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
                : null,
        boxShadow: [BoxShadow(color: Colors.black)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              leading,
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ...?actions,
            ],
          ),
          const SizedBox(height: 5),
          bottomAppbar != null ? bottomAppbar! : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
