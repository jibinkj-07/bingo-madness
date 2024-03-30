import 'package:flutter/material.dart';

import '../../../../lobby/presentation/view_model/game_operations.dart';
import '../../../model/game_model.dart';

/// @author : Jibin K John
/// @date   : 30/03/2024
/// @time   : 09:45:37

class Profile extends StatelessWidget {
  final bool isHost;
  final GameModel gameModel;

  const Profile({
    super.key,
    required this.gameModel,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    final playerName = isHost ? gameModel.hostName : gameModel.opponentName;
    final isActive = GameOperations.isMyTurn(gameModel, playerName);
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: isActive ? Colors.green : Colors.amber.shade100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isHost)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                playerName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : null,
                ),
              ),
            ),
          CircleAvatar(
            radius: 17.0,
            backgroundColor: isActive ? Colors.white : Colors.blue.shade200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset(
                isHost ? "assets/images/female.png" : "assets/images/male.png",
                height: 40.0,
                width: 40.0,
              ),
            ),
          ),
          if (isHost)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                playerName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
