import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.disabled = false,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: !disabled ? onPressed : null,
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor:
            !disabled ? Colors.purple.shade500 : Colors.purple.shade300,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      ),
      child: child,
    );
  }
}
