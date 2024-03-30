import 'dart:developer';
import 'dart:math' hide log;

import 'package:bingo/features/game/model/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../provider/game_provider.dart';

class GameOperations {
  /// Struck matrix items like row index, column index, diagonal indices
  /// diagonal index = 1
  /// anti diagonal index = 2
  /// row index = 1[index of row]
  /// column index =2[index of col]

  static final ValueNotifier<List<int>> struckMatrix = ValueNotifier([]);

  static Future<String> createGame({
    required String hostName,
    required String roomId,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      final gameModel = GameModel(
        roomId: roomId,
        hostName: hostName,
        opponentName: "",
        struckNumbers: [],
        currentNumber: 0,
        winner: "",
        lastPlayed: "",
        message: "",
        reaction: "",
        replay: false,
      );
      await FirebaseFirestore.instance
          .collection("game")
          .doc(roomId)
          .set(gameModel.toJson());
      return "";
    } catch (e) {
      log("Error [createGame] $e");
      return "Unable to create game. Try again";
    }
  }

  static Future<String> joinGame({
    required String opponentName,
    required String roomId,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      final roomData =
          await FirebaseFirestore.instance.collection("game").doc(roomId).get();

      /// return error if room id not exist
      if (!roomData.exists) {
        return "No room created with this id";
      }
      final roomDataValue = roomData.data() as Map<String, dynamic>;

      /// return error if opponent is already occupied
      if (roomDataValue["opponent"].toString().isNotEmpty) {
        return "Room is already occupied its maximum players";
      }

      /// return error if opponent name == host name
      if (roomDataValue["host"].toString() == opponentName) {
        return "Kindly choose different name";
      }

      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "opponent": opponentName,
      });
      return "";
    } catch (e) {
      log("Error [joinGame] $e");
      return "Unable to join game. Try again";
    }
  }

  static bool isMyTurn(GameModel gameModel, String playerName) {
    final isHost = playerName == gameModel.hostName;

    /// If last played user is empty and current user is host then his turn
    if (gameModel.lastPlayed.isEmpty && isHost) {
      return true;
    } else if (gameModel.lastPlayed.isEmpty && !isHost) {
      return false;
    } else if (gameModel.lastPlayed.isNotEmpty &&
        gameModel.lastPlayed == playerName) {
      return false;
    } else {
      return true;
    }
  }

  static bool isStruck(List<int> struck, int element) =>
      struck.contains(element);

  static void isFullyStruck(List<int> struck, BuildContext context) {
    struckMatrix.value.clear();
    final matrix = Provider.of<GameProvider>(context, listen: false).gameMatrix;

    int dCount = 0;
    int antiDCount = 0;

    for (int i = 0; i < matrix.length; i++) {
      // Checking diagonal elements
      if (struck.contains(matrix[i][i])) {
        dCount += 1;
      }

      // Checking anti-diagonal elements
      if (struck.contains(matrix[i][matrix.length - 1 - i])) {
        antiDCount += 1;
      }

      int rowCount = 0;
      int colCount = 0;
      for (int j = 0; j < matrix[i].length; j++) {
        // Checking row elements
        if (struck.contains(matrix[i][j])) {
          rowCount++;
        }
        // Checking column elements
        if (struck.contains(matrix[j][i])) {
          colCount++;
        }
      }

      if (rowCount == matrix.length) {
        struckMatrix.value.add(10 + i);
      }
      if (colCount == matrix.length) {
        struckMatrix.value.add(20 + i);
      }
    }

    if (dCount == matrix.length) {
      struckMatrix.value.add(1);
    }
    if (antiDCount == matrix.length) {
      struckMatrix.value.add(2);
    }
    struckMatrix.notifyListeners();
  }

  static Future<String> strikeElement({
    required int element,
    required String player,
    required String roomId,
    required List<int> struckList,
  }) async {
    final struck = List.from(struckList);
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      if (!struck.contains(element)) {
        struck.add(element);
      }

      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "current": element,
        "struck": struck.toList(),
        "last_played": player,
      });
      return "";
    } catch (e) {
      log("Error [strikeElement] $e");
      return "Unable to strike element. Try again";
    }
  }

  static Future<String> sendReaction({
    required String roomId,
    required String reaction,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "reaction": reaction,
      });
      return "";
    } catch (e) {
      log("Error [sendReaction] $e");
      return "Unable to send reaction. Try again";
    }
  }

  static Future<String> exitMatch({
    required String roomId,
    required bool isHost,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      Map<String, dynamic> data = {
        "current": 0,
        "struck": [],
        "last_played": "",
        "winner": "",
        "message": "",
        "replay": false,
      };
      if (isHost) {
        data["host"] = "";
      } else {
        data["opponent"] = "";
      }
      await FirebaseFirestore.instance
          .collection("game")
          .doc(roomId)
          .update(data);
      return "";
    } catch (e) {
      log("Error [exitMatch] $e");
      return "Unable to exit match. Try again";
    }
  }

  static Future<String> replayMatch(
      {required String roomId, required String player}) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "current": 0,
        "host": player,
        "opponent": "",
        "struck": [],
        "last_played": "",
        "message": "",
        "replay": true,
      });
      return "";
    } catch (e) {
      log("Error [replayMatch] $e");
      return "Unable to replay match. Try again";
    }
  }

  static Future<String> acceptReMatch(
      {required String roomId, required String player}) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "opponent": player,
        "replay": false,
        "winner": "",
      });
      return "";
    } catch (e) {
      log("Error [acceptReMatch] $e");
      return "Unable to accept re- match. Try again";
    }
  }

  static Future<String> sendMessage({
    required String message,
    required String player,
    required String roomId,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "message": "[$player] $message",
      });
      return "";
    } catch (e) {
      log("Error [sendMessage] $e");
      return "Unable to send message. Try again";
    }
  }

  static Future<String> bingo({
    required String player,
    required String roomId,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).update({
        "winner": player,
      });
      return "";
    } catch (e) {
      log("Error [bingo] $e");
      return "Unable to call bingo. Try again";
    }
  }

  static Future<String> deleteRoom({
    required String roomId,
  }) async {
    if (!await InternetConnectionChecker().hasConnection) {
      return "Check your network connection";
    }
    try {
      await FirebaseFirestore.instance.collection("game").doc(roomId).delete();
      return "";
    } catch (e) {
      log("Error [deleteRoom] $e");
      return "Unable to delete room. Try again";
    }
  }

  static String generateRandomWord() {
    Random random = Random();
    String alphabet = 'abcdefghijklmnopqrstuvwxyz';
    int index1 = random.nextInt(alphabet.length);
    int index2 = random.nextInt(alphabet.length);
    String randomLetters = alphabet[index1] + alphabet[index2];

    // Generate random numbers
    String randomNumbers = '';
    for (int i = 0; i < 4; i++) {
      randomNumbers += random.nextInt(10).toString();
    }

    // Concatenate first two letters with random numbers
    String randomWord = randomLetters + randomNumbers;

    return randomWord.toUpperCase();
  }

  static List<String> getConvertedList(String string) {
    List<String> message = [];
    // Remove brackets
    String withoutBrackets = string.replaceAll(RegExp(r'[\[\]]'), '');

    // Split the string by space
    List<String> parts = withoutBrackets.split(" ");

    if (parts.length >= 2) {
      String firstPart = parts[0];
      String secondPart = parts.sublist(1).join(" ");

      message.add(firstPart); // Output: Hey
      message.add(secondPart); // Output: hello
    } else {
      log("Invalid input format");
    }
    return message;
  }
}
