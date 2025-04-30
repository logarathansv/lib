import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.icon,
    this.radius,
    this.isOutlined = false,
  });

  final String title;
  final VoidCallback onTap;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final IconData? icon;
  final double? radius;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 10.0),
        height: height ?? 50.0,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          gradient: isOutlined ? null : LinearGradient(
            colors: [
              color ?? kPrimaryColor,
              color?.withOpacity(0.8) ?? kPrimaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(radius ?? 15.0),
          border: isOutlined ? Border.all(
            color: color ?? kPrimaryColor,
            width: 2.0,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: (color ?? kPrimaryColor).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius ?? 15.0),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      icon,
                      color: isOutlined ? (color ?? kPrimaryColor) : Colors.white,
                      size: 20,
                    ),
                  ),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: isOutlined ? (color ?? kPrimaryColor) : Colors.white,
                    fontSize: fontSize ?? 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
