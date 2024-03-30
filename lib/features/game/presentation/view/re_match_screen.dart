import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../core/util/widgets/game_bg.dart';
import '../../../lobby/presentation/provider/game_provider.dart';
import '../../../lobby/presentation/view_model/game_operations.dart';
import '../../../lobby/presentation/widget/game_board.dart';
import 'game_screen.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 17:26:25

class ReMatchScreen extends StatefulWidget {
  final bool sendingInvite;
  final String playerName;
  final String roomId;

  const ReMatchScreen({
    super.key,
    required this.sendingInvite,
    required this.playerName,
    required this.roomId,
  });

  @override
  State<ReMatchScreen> createState() => _ReMatchScreenState();
}

class _ReMatchScreenState extends State<ReMatchScreen> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameBG(
      topBarChild: const SizedBox.shrink(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const GameBoard(),
          AnimatedButton(
            width: 250,
            height: 50.0,
            title: const Text(
              "Ready",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (Provider.of<GameProvider>(context, listen: false)
                  .containsZero) {
                CustomSnackBar.showErrorSnackBar(
                  context,
                  "Configure your bingo table",
                );
              } else if (widget.sendingInvite) {
                _loading.value = true;
                GameOperations.replayMatch(
                        roomId: widget.roomId, player: widget.playerName)
                    .then((response) {
                  _loading.value = false;
                  if (response.isEmpty) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => GameScreen(
                          roomId: widget.roomId,
                          playerName: widget.playerName,
                        ),
                      ),
                    );
                  } else {
                    CustomSnackBar.showErrorSnackBar(context, response);
                  }
                });
              } else {
                _loading.value = true;
                GameOperations.acceptReMatch(
                        roomId: widget.roomId, player: widget.playerName)
                    .then((response) {
                  _loading.value = false;
                  if (response.isEmpty) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => GameScreen(
                          roomId: widget.roomId,
                          playerName: widget.playerName,
                        ),
                      ),
                    );
                  } else {
                    CustomSnackBar.showErrorSnackBar(context, response);
                  }
                });
              }
            },
            isBoxShadow: true,
            bgColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
