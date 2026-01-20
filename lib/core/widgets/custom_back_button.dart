import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: color ?? AppColors.black),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
