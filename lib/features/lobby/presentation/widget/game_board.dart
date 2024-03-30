import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/constants/app_color.dart';
import '../../../../core/util/helper/matrix_operations.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../provider/game_provider.dart';

/// @author : Jibin K John
/// @date   : 26/03/2024
/// @time   : 15:41:24

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          padding: const EdgeInsets.all(20.0),
          width: size.width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
            image: DecorationImage(
              image: const AssetImage("assets/images/wooden.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.2),
                BlendMode.multiply,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Configure Bingo table",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 25,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                itemBuilder: (ctx, index) {
                  final row = MatrixOperations.getRow(index);
                  final col = MatrixOperations.getColumn(index);

                  return Consumer<GameProvider>(
                    builder: (ctx, provider, _) {
                      final element = provider.gameMatrix[row][col];

                      return IconButton.filled(
                        onPressed: () => _showBottomDialog(row, col),
                        style: IconButton.styleFrom(
                          backgroundColor: element > 0
                              ? AppColor.secondaryColor
                              : Colors.grey.shade300,
                        ),
                        icon: Text(
                          element > 0 ? element.toString() : "-",
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedButton(
              width: 100,
              height: 40,
              title: const Text(
                "Random",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Provider.of<GameProvider>(context, listen: false).gameMatrix =
                    MatrixOperations.generateRandomMatrix();
              },
              isBoxShadow: false,
              bgColor: Colors.pink,
              borderRadius: 10.0,
            ),
            AnimatedButton(
              width: 100,
              height: 40,
              title: const Text(
                "Clear",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Provider.of<GameProvider>(context, listen: false).resetMatrix();
              },
              isBoxShadow: false,
              bgColor: Colors.pink,
              borderRadius: 10.0,
            ),
          ],
        )
      ],
    );
  }

  PersistentBottomSheetController _showBottomDialog(int row, int col) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final numbers = provider.generateListNotInGameMatrix();
    return showBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/wooden.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.2),
                  BlendMode.multiply,
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose number",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (numbers.isNotEmpty)
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: numbers.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      itemBuilder: (ctx, index) {
                        return IconButton.filled(
                          onPressed: () {
                            provider.addElement(row, col, numbers[index]);
                            Navigator.pop(ctx);
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white),
                          icon: Text(
                            numbers[index].toString(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      "No numbers left",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
