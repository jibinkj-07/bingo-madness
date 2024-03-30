import 'dart:ui';
import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 11:51:31

class GameBG extends StatelessWidget {
  final Widget topBarChild;
  final Widget child;
  final Widget? button;

  const GameBG({
    super.key,
    required this.topBarChild,
    required this.child,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/game_bg.jpg"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(.25),
              BlendMode.multiply,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.viewPaddingOf(context).top,
                    left: 10.0,
                    right: 10.0,
                    bottom: 15.0,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30.0),
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
                  child: topBarChild,
                ),
                Expanded(child: Center(child: child)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: button ?? button,
    );
  }
}
