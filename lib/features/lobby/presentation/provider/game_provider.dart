import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  List<List<int>> _gameMatrix = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];

  List<List<int>> get gameMatrix => _gameMatrix;

  set gameMatrix(List<List<int>> matrix) {
    _gameMatrix = matrix;
    notifyListeners();
  }

  void addElement(int row, int col, int element) {
    _gameMatrix[row][col] = element;
    notifyListeners();
  }

  List<int> generateListNotInGameMatrix() {
    // Create a Set to store all numbers present in list b
    Set<int> numbersInB = {};

    // Iterate through each list in b and add its elements to the Set
    for (List<int> sublist in _gameMatrix) {
      numbersInB.addAll(sublist);
    }

    // Create a list to store numbers not present in list b
    List<int> a = [];

    // Iterate through numbers from 1 to 25
    for (int num = 1; num <= 25; num++) {
      // Check if the number is not present in list b
      if (!numbersInB.contains(num)) {
        a.add(num); // Add the number to list a
      }
    }

    return a;
  }

  bool get containsZero {
    // Iterate through each sublist in the main list
    for (List<int> sublist in _gameMatrix) {
      // Iterate through each element in the sublist
      for (int element in sublist) {
        if (element == 0) {
          return true; // If a zero element is found, return true
        }
      }
    }
    return false; // If no zero element is found, return false
  }

  void resetMatrix() {
    _gameMatrix = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ];
    notifyListeners();
  }
}
