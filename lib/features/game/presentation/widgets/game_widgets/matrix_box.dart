import 'package:audioplayers/audioplayers.dart';
import 'package:bingo/features/game/model/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/util/helper/matrix_operations.dart';
import '../../../../../main.dart';
import '../../../../lobby/presentation/provider/game_provider.dart';
import '../../../../lobby/presentation/view_model/game_operations.dart';
import '../../../../settings/presentation/provider/setting_provider.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 14:07:33

class MatrixBox extends StatelessWidget {
  final GameModel gameModel;
  final String player;

  const MatrixBox({
    super.key,
    required this.gameModel,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        border: Border.all(width: 5, color: Colors.amber.shade800),
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
            blurRadius: 20.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 25,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
        ),
        itemBuilder: (ctx, index) {
          return Consumer<GameProvider>(
            builder: (ctx, gameProvider, _) {
              final row = MatrixOperations.getRow(index);
              final col = MatrixOperations.getColumn(index);

              return ValueListenableBuilder(
                valueListenable: GameOperations.struckMatrix,
                builder: (ctx1, struckMatrix, _) {
                  bool allStruck = false;
                  if ((struckMatrix.contains(1) && row == col) ||
                      (struckMatrix.contains(2) && row + col == 4) ||
                      struckMatrix.contains(row + 10) ||
                      struckMatrix.contains(col + 20)) {
                    allStruck = true;
                  }

                  return ElevatedButton(
                    onPressed: allStruck
                        ? null
                        : () {
                            if (GameOperations.isMyTurn(gameModel, player)) {
                              final provider = Provider.of<SettingProvider>(
                                  context,
                                  listen: false);
                              if (provider.appSound) {
                                matrixButtonSound.value.resume();
                              }
                              HapticFeedback.mediumImpact();
                              GameOperations.strikeElement(
                                element: gameProvider.gameMatrix[row][col],
                                player: player,
                                roomId: gameModel.roomId,
                                struckList: gameModel.struckNumbers,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: gameModel.currentNumber ==
                              gameProvider.gameMatrix[row][col]
                          ? Colors.amber.shade700
                          : GameOperations.isStruck(
                              gameModel.struckNumbers,
                              gameProvider.gameMatrix[row][col],
                            )
                              ? Colors.blue
                              : null,
                      foregroundColor: GameOperations.isStruck(
                        gameModel.struckNumbers,
                        gameProvider.gameMatrix[row][col],
                      )
                          ? Colors.white
                          : null,
                    ),
                    child: Text(
                      gameProvider.gameMatrix[row][col].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
