import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/game_bg.dart';
import '../../../../main.dart';
import '../../../lobby/presentation/provider/game_provider.dart';
import '../../../lobby/presentation/view_model/game_operations.dart';
import 're_match_screen.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 15:02:31

class ResultScreen extends StatefulWidget {
  final bool isSuccess;
  final bool isSound;
  final String roomId;
  final String playerName;
  final String hostName;
  final bool isReplay;

  const ResultScreen({
    super.key,
    required this.isSuccess,
    required this.roomId,
    required this.isSound,
    required this.isReplay,
    required this.playerName,
    required this.hostName,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.isSound) {
        widget.isSuccess
            ? victorySound.value.resume()
            : failedSound.value.resume();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GameBG(
      topBarChild: const SizedBox.shrink(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              border: Border.all(width: 5, color: Colors.amber.shade800),
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade50,
                  Colors.amber.shade200,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  widget.isSuccess
                      ? "assets/animations/party.json"
                      : "assets/animations/lose.json",
                ),
                Image.asset(widget.isSuccess
                    ? "assets/images/victory.png"
                    : "assets/images/lose.png"),
                Text(
                  widget.isSuccess ? getRandomQuote() : "Never give up",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
          AnimatedButton(
            height: 50.0,
            title: Text(
              widget.isReplay ? "Accept re-Match" : "Match again",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).resetMatrix();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ReMatchScreen(
                    sendingInvite: !widget.isReplay,
                    playerName: widget.playerName,
                    roomId: widget.roomId,
                  ),
                ),
              );
            },
            isBoxShadow: true,
            bgColor: Colors.blue,
          ),
          const SizedBox(height: 15.0),
          AnimatedButton(
            width: 120,
            height: 50.0,
            title: const Text(
              "Exit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).resetMatrix();
              GameOperations.exitMatch(
                roomId: widget.roomId,
                isHost: widget.playerName == widget.hostName,
              );
              Navigator.pop(context);
            },
            isBoxShadow: true,
            bgColor: Colors.red,
          ),
        ],
      ),
    );
  }

  List<String> quotes = [
    "Dream big",
    "Keep going",
    "Make it happen",
    "Seize the day",
    "Chase your dreams",
    "You've got this",
    "Winner winner chicken dinner",
    "You got this",
    "You are the best",
    "Victory belongs to you"
  ];

  String getRandomQuote() {
    Random random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
