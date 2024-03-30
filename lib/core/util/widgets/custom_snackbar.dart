import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) =>
      _snackbar(
        context: context,
        bgColor: Colors.red,
        textColor: Colors.white,
        message: message,
        icon: const Icon(
          Icons.error_rounded,
          size: 20.0,
          color: Colors.white,
        ),
      );

  static void showSuccessSnackBar(BuildContext context, String message) =>
      _snackbar(
        context: context,
        bgColor: Colors.green,
        textColor: Colors.white,
        message: message,
        icon: const Icon(
          Icons.check_circle_rounded,
          size: 20.0,
          color: Colors.white,
        ),
      );

  static void _snackbar({
    required BuildContext context,
    required Color bgColor,
    required Color textColor,
    required String message,
    required Widget icon,
  }) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: size.height - size.height * .25,
          right: 10,
          left: 10,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: bgColor,
            border: Border.all(
              width: 3,
              color: AppColor.secondaryColor,
            ),
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(message, style: TextStyle(color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
