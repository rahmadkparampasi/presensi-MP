import 'package:flutter/material.dart';

class ButtonDTP extends StatelessWidget {
  final IconButton child;
  const ButtonDTP({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(),
      ),
      width: 38,
      height: 38,
      child: child,
    );
  }
}
