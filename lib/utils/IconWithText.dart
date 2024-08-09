

import 'package:flutter/cupertino.dart';
import 'package:itunes/utils/app_utils.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  IconWithText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 38.0,
          color: AppUtils.whiteColor,
        ),
        const SizedBox(width: 1.0), // Spacing between icon and text
        Text(text,
            style:
            AppUtils.fontStyle(20.0, AppUtils.whiteColor, FontWeight.bold)),
      ],
    );
  }
}