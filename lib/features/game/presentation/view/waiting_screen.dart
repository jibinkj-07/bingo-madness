import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/util/widgets/game_bg.dart';

/// @author : Jibin K John
/// @date   : 28/03/2024
/// @time   : 11:33:40

class WaitingScreen extends StatelessWidget {
  final String roomId;

  const WaitingScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return GameBG(
      topBarChild: const Center(
        child: Text(
          "Waiting for opponent",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 100.0,
            ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  roomId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
                const Text(
                  "Share your room id to join other player",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () async {
              final bytes = await rootBundle.load('assets/images/app_logo.png');
              final list = bytes.buffer.asUint8List();

              final tempDir = await getTemporaryDirectory();
              final file = await File('${tempDir.path}/image.jpg').create();
              file.writeAsBytesSync(list);

              Share.shareXFiles(
                [XFile(file.path)],
                subject: "Bingo Madness",
                text:
                    "Hey there! Wanna join the Bingo Madness game with me. Use the code "
                    "$roomId? Let's have a blast together! 🎉",
              );
            },
            label: const Text("Share"),
            icon: const Icon(Icons.share_rounded),
          )
        ],
      ),
    );
  }
}
