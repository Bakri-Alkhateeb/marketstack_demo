import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const ActionButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Iconify(
        icon,
        color: Colors.white,
      ),
    );
  }
}
