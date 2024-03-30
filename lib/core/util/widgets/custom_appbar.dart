import 'package:flutter/material.dart';

import 'animated_button.dart';

/// @author : Jibin K John
/// @date   : 26/03/2024
/// @time   : 22:18:49

class CustomAppBar extends StatelessWidget {
  final String title;
  final Color? color;

  const CustomAppBar({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.viewPaddingOf(context).top,
        left: 20.0,
        bottom: 15.0,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40.0),
        ),
        border: const Border(
          left: BorderSide(width: 2, color: Colors.white),
          right: BorderSide(width: 2, color: Colors.white),
          bottom: BorderSide(width: 2, color: Colors.white),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade200,
            Colors.amber.shade800,
          ],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          AnimatedButton(
            width: 40.0,
            height: 40.0,
            title: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 30.0,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            isBoxShadow: false,
            bgColor: color ?? Colors.blue,
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
