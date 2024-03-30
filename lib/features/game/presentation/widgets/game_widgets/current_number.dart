import 'package:bingo/features/game/model/game_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/util/widgets/animated_button.dart';
import '../../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../../core/util/widgets/custom_text_field.dart';
import '../../../../../core/util/widgets/sound_button.dart';
import '../../../../lobby/presentation/view_model/game_operations.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 14:04:45

class CurrentNumber extends StatelessWidget {
  final Size size;
  final GameModel gameModel;
  final String player;

  const CurrentNumber({
    super.key,
    required this.size,
    required this.gameModel,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AnimatedButton(
          width: 50.0,
          height: 50.0,
          title: const Icon(
            Icons.chat_rounded,
            size: 25.0,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Message'),
                  content: CustomTextField(
                    autoFocus: true,
                    textFieldKey: "message",
                    isObscure: false,
                    hintText: "Text message",
                    inputAction: TextInputAction.send,
                    textCapitalization: TextCapitalization.sentences,
                    borderRadius: 10.0,
                    onFieldSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        GameOperations.sendMessage(
                          message: value.toString().trim(),
                          player: player,
                          roomId: gameModel.roomId,
                        ).then((value) {
                          if (value.isNotEmpty) {
                            CustomSnackBar.showErrorSnackBar(context, value);
                          }
                        });
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                  actions: <Widget>[
                    AnimatedButton(
                      height: 40.0,
                      width: 120.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      title: const Text("Cancel"),
                      isBoxShadow: false,
                    ),
                  ],
                );
              },
            );
          },
          isBoxShadow: false,
          bgColor: Colors.blue,
        ),
        Container(
          height: size.width * .2,
          width: size.width * .2,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.grey),
            gradient: RadialGradient(
              colors: [
                Colors.amber.shade100,
                Colors.amber.shade300,
              ],
            ),
          ),
          child: Center(
            child: Text(
              gameModel.currentNumber == 0
                  ? "Start"
                  : gameModel.currentNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: gameModel.currentNumber == 0 ? 20.0 : 30.0,
              ),
            ),
          ),
        ),
        const SoundButton(color: Colors.blue),
      ],
    );
  }
}
