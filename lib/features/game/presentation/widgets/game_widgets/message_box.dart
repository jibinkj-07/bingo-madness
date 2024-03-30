import 'package:bingo/features/game/model/game_model.dart';
import 'package:flutter/material.dart';
import '../../../../lobby/presentation/view_model/game_operations.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 14:14:04

class MessageBox extends StatelessWidget {
  final GameModel gameModel;

  const MessageBox({super.key, required this.gameModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(10.0),
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
      child: gameModel.message.isEmpty
          ? const Text(
              "Messages will show here",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black54,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10.0,
                        backgroundColor: Colors.blue.shade200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                            GameOperations.getConvertedList(gameModel.message)
                                        .first ==
                                    gameModel.hostName
                                ? "assets/images/female.png"
                                : "assets/images/male.png",
                            height: 40.0,
                            width: 40.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          GameOperations.getConvertedList(gameModel.message)
                              .first,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  GameOperations.getConvertedList(gameModel.message).last,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
    );
  }
}
