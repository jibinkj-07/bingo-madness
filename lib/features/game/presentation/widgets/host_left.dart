import 'package:flutter/material.dart';

import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/game_bg.dart';
import '../../../lobby/presentation/view_model/game_operations.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 18:30:20

class HostLeft extends StatelessWidget {
  final String roomId;

  const HostLeft({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return GameBG(
      topBarChild: const SizedBox.shrink(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Host left the room",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          AnimatedButton(
            height: 50.0,
            onPressed: () {
              GameOperations.deleteRoom(roomId: roomId);
              Navigator.pop(context);
            },
            title: const Text(
              "Exit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            bgColor: Colors.red,
            isBoxShadow: true,
          ),
        ],
      ),
    );
  }
}
