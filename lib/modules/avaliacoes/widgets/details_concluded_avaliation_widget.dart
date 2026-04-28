import 'package:flutter/material.dart';

class DetailsConcludedAvaliationWidget extends StatelessWidget {
  final int totaldiscretions;
  final int concludedsDiscretions;
  final double penality;
  const DetailsConcludedAvaliationWidget({
    super.key,
    required this.totaldiscretions,
    required this.concludedsDiscretions,
    required this.penality,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.grey.shade600, fontSize: 11);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('$totaldiscretions critérios', style: textStyle)],
        ),
        Text('|', style: textStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$concludedsDiscretions cumpridos', style: textStyle),
          ],
        ),
        Text('|', style: textStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Penalidade ${penality.toStringAsFixed(2)}', style: textStyle),
          ],
        ),
      ],
    );
  }
}
