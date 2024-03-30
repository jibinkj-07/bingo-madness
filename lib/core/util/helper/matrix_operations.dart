import 'dart:math';

class MatrixOperations {
  static List<List<int>> generateRandomMatrix() {
    Random random = Random();
    List<List<int>> matrix = [];
    Set<int> usedNumbers = <int>{};

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        int randomNumber;
        do {
          randomNumber =
              random.nextInt(25) + 1; // Generates random numbers from 1 to 25
        } while (usedNumbers.contains(randomNumber));
        if (matrix.length <= i) {
          matrix.add([randomNumber]);
        } else {
          matrix[i].add(randomNumber);
        }

        usedNumbers.add(randomNumber);
      }
    }
    return matrix;
  }

  static int getRow(int index) => (index ~/ 5).clamp(0, 4);

  static int getColumn(int index) => index % 5;
}
