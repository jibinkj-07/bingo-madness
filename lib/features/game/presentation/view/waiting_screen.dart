import 'package:flutter/material.dart';

import '../../../../core/util/widgets/game_bg.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 11:33:40

class WaitingScreen extends StatelessWidget {
  final String roomId;

  const WaitingScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return GameBG(
      topBarChild: const Center(
        child: Text(
          "Waiting for opponent",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(horizontal: 50.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade300,
              Colors.amber.shade100,
              Colors.amber.shade300,
            ],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 50.0,
              spreadRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              roomId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
            const Text(
              "Share your room id to join other player",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
