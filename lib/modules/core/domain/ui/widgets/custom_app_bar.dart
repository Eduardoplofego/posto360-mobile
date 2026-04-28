import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget leading;
  final List<Widget>? actions;
  final bool withRoundedBorders;
  final Widget? bottomAppbar;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.leading,
    this.actions,
    this.withRoundedBorders = true,
    this.bottomAppbar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
