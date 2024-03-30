import 'dart:developer';
import 'package:bingo/core/util/widgets/game_bg.dart';
import 'package:bingo/features/game/model/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../lobby/presentation/view_model/game_operations.dart';
import '../widgets/main_body.dart';

/// @author : Jibin K John
/// @date   : 26/03/2024
/// @time   : 23:17:16

class GameScreen extends StatefulWidget {
  final String playerName;
  final String roomId;

  const GameScreen({
    super.key,
    required this.playerName,
    required this.roomId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ValueNotifier<GameModel?> _gameModel = ValueNotifier(null);

  @override
  void dispose() {
    _gameModel.dispose();
    if (_gameModel.value != null) {
      GameOperations.exitMatch(
        roomId: _gameModel.value!.roomId,
        isHost: widget.playerName == _gameModel.value!.hostName,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("game")
          .doc(widget.roomId)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        /// Handle case where data is under loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GameBG(
            topBarChild: Text(""),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              backgroundColor: Colors.white,
            ),
          ); // Or any loading indicator
        }

        /// Handle case where document doesn't exist
        if (!snapshot.hasData || snapshot.data == null) {
          return const GameBG(
            topBarChild: Text(""),
            child: Text(
              "No details found. Restart Game",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
          );
        }

        try {
          /// Handle case where data is present
          final data = snapshot.data!.data() as Map<String, dynamic>;
          _gameModel.value = GameModel.fromFirebase(data, widget.roomId);
        } catch (e) {
          log("Error $e");
        }

        return MainBody(
          gameModel: _gameModel,
          size: size,
          playerName: widget.playerName,
        );
      },
    );
  }
}
