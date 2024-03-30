class GameModel {
  final String roomId;
  final String hostName;
  final String opponentName;
  final List<int> struckNumbers;
  final int currentNumber;
  final String winner;
  final String lastPlayed;
  final String message;
  final String reaction;
  final bool replay;

  GameModel({
    required this.roomId,
    required this.hostName,
    required this.opponentName,
    required this.struckNumbers,
    required this.currentNumber,
    required this.winner,
    required this.lastPlayed,
    required this.message,
    required this.reaction,
    required this.replay,
  });

  Map<String, dynamic> toJson() {
    return {
      "host": hostName,
      "opponent": opponentName,
      "struck": struckNumbers,
      "current": currentNumber,
      "winner": winner,
      "last_played": lastPlayed,
      "message": message,
      "replay": replay,
      "reaction": reaction,
    };
  }

  factory GameModel.fromFirebase(Map<String, dynamic> data, String roomId) {
    final struck = data["struck"] as List<dynamic>;
    return GameModel(
      roomId: roomId,
      hostName: data["host"].toString(),
      opponentName: data["opponent"].toString(),
      struckNumbers: struck.map((e) => int.parse(e.toString())).toList(),
      currentNumber: data["current"],
      winner: data["winner"].toString(),
      lastPlayed: data["last_played"].toString(),
      message: data["message"].toString(),
      replay: data["replay"],
      reaction: data["reaction"],
    );
  }
}
