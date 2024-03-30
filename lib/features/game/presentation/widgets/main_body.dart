import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../core/util/widgets/game_bg.dart';
import '../../../lobby/presentation/view_model/game_operations.dart';
import '../../../settings/presentation/provider/setting_provider.dart';
import '../../model/game_model.dart';
import '../view/result_screen.dart';
import '../view/waiting_screen.dart';
import 'game_widgets/current_number.dart';
import 'game_widgets/score.dart';
import 'game_widgets/header.dart';
import 'game_widgets/matrix_box.dart';
import 'game_widgets/message_box.dart';
import 'host_left.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 12:50:33

class MainBody extends StatelessWidget {
  final ValueNotifier<GameModel?> gameModel;
  final Size size;
  final String playerName;

  const MainBody({
    super.key,
    required this.gameModel,
    required this.size,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gameModel,
      builder: (ctx, game, _) {
        if (game == null ||
            (game.hostName == playerName && game.opponentName.isEmpty)) {
          return WaitingScreen(roomId: game?.roomId ?? "Retry");
        }

        /// Handle no host scenario
        if (game.hostName.isEmpty) {
          return HostLeft(roomId: game.roomId);
        }

        /// Handle winning state
        if (game.winner.isNotEmpty) {
          return ResultScreen(
            isSound: Provider.of<SettingProvider>(
              context,
              listen: false,
            ).appSound,
            roomId: game.roomId,
            isSuccess: game.winner == playerName,
            isReplay: game.replay,
            playerName: playerName,
            hostName: game.hostName,
          );
        }

        /// Checking struck elements every time widget gets refresh
        GameOperations.isFullyStruck(game.struckNumbers, context);

        /// Make reaction empty after 2 sec to resume game screen
        if (game.reaction.isNotEmpty) {
          Future.delayed(
            const Duration(milliseconds: 2500),
            () =>
                GameOperations.sendReaction(roomId: game.roomId, reaction: ""),
          );
        }

        return Stack(
          children: [
            GameBG(
              topBarChild: Header(
                size: size,
                gameModel: game,
                player: playerName,
              ),
              button: AnimatedButton(
                width: size.width * .4,
                height: 60.0,
                title: const Text(
                  "BINGO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                onPressed: () {
                  if (GameOperations.struckMatrix.value.length < 5) {
                    CustomSnackBar.showErrorSnackBar(
                      context,
                      "Bad Bingo. Keep playing",
                    );
                  } else {
                    GameOperations.bingo(
                            player: playerName, roomId: game.roomId)
                        .then((response) {
                      if (response.isNotEmpty) {
                        CustomSnackBar.showErrorSnackBar(context, response);
                      }
                    });
                  }
                },
                isBoxShadow: true,
                bgColor: Colors.blue,
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0),
                children: [
                  CurrentNumber(
                      size: size, gameModel: game, player: playerName),
                  MatrixBox(gameModel: game, player: playerName),
                  Score(roomId: game.roomId, playerName: playerName),
                  MessageBox(gameModel: game),
                ],
              ),
            ),
            if (game.reaction.isNotEmpty)
              Container(
                width: double.infinity,
                height: size.height,
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: Lottie.asset(_getAnimation(game.reaction)),
              ),
          ],
        );
      },
    );
  }

  String _getAnimation(String reaction) {
    switch (reaction) {
      case "love":
        return "assets/animations/reaction_love.json";
      case "angry":
        return "assets/animations/reaction_angry.json";
      case "kiss":
        return "assets/animations/reaction_kiss.json";
      case "smash":
        return "assets/animations/reaction_smash.json";
      case "alarm":
        return "assets/animations/reaction_time.json";
      default:
        return "assets/animations/reaction_party.json";
    }
  }
}
