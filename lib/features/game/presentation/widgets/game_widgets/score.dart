import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/util/widgets/animated_button.dart';
import '../../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../lobby/presentation/view_model/game_operations.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 14:13:07

class Score extends StatelessWidget {
  final String roomId;
  final String playerName;

  const Score({
    super.key,
    required this.roomId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: GameOperations.struckMatrix,
          builder: (ctx1, struckMatrix, _) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              margin: const EdgeInsets.only(bottom: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.amber.shade100,
              ),
              child: Text(
                "Score : ${struckMatrix.length}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: struckMatrix.length > 4 ? Colors.pink : Colors.black,
                ),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            6,
            (index) => AnimatedButton(
              height: 45.0,
              width: 45.0,
              title: SvgPicture.asset(
                _getIcon(index),
                width: 30.0,
                height: 30.0,
              ),
              onPressed: () {
                GameOperations.sendReaction(
                        roomId: roomId, reaction: _getReaction(index))
                    .then((value) {
                  if (value.isNotEmpty) {
                    CustomSnackBar.showErrorSnackBar(context, value);
                  }
                });
              },
              bgColor: Colors.white,
              isBoxShadow: false,
            ),
          ),
        )
      ],
    );
  }

  String _getIcon(int index) {
    switch (index) {
      case 1:
        return "assets/svg/love.svg";
      case 2:
        return "assets/svg/kiss.svg";
      case 3:
        return "assets/svg/angry.svg";
      case 4:
        return "assets/svg/smash.svg";
      case 5:
        return "assets/svg/alarm.svg";
      default:
        return "assets/svg/party.svg";
    }
  }

  String _getReaction(int index) {
    switch (index) {
      case 1:
        return "love";
      case 2:
        return "kiss";
      case 3:
        return "angry";
      case 4:
        return "smash";
      case 5:
        return "alarm";
      default:
        return "party";
    }
  }
}
