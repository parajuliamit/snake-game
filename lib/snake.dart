import 'package:flutter/material.dart';

import 'constants.dart';

class Snake extends StatelessWidget {
  const Snake({Key? key, required this.x, required this.y}) : super(key: key);

  final int x;
  final int y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y.toDouble(),
      left: x.toDouble(),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
        width: size.toDouble(),
        height: size.toDouble(),
      ),
    );
  }
}
