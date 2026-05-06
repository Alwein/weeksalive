import 'package:flutter/material.dart';

class NotchLogo extends StatelessWidget {
  const NotchLogo({super.key, required this.size});
  final BoxConstraints size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/app_name_hidden.png",
      fit: BoxFit.contain,
      width: size.maxWidth,
      height: size.maxHeight,
    );
  }
}
