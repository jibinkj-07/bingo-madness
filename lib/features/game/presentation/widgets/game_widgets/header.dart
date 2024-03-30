import 'package:bingo/features/game/presentation/widgets/game_widgets/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../lobby/presentation/view_model/game_operations.dart';
import '../../../model/game_model.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 14:01:36

class Header extends StatelessWidget {
  final Size size;
  final GameModel gameModel;
  final String player;

  const Header({
    super.key,
    required this.size,
    required this.gameModel,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Profile(gameModel: gameModel,isHost: true),
        Flexible(
          child: Text(
            GameOperations.isMyTurn(gameModel, player)
                ? "Your turn"
                : "${gameModel.hostName == player ? gameModel.opponentName : gameModel.hostName}\'s turn",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Profile(gameModel: gameModel,isHost: false),
      ],
    );
  }
}
