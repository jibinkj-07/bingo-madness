import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/custom_appbar.dart';
import '../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../../game/presentation/view/game_screen.dart';
import '../provider/game_provider.dart';
import '../view_model/game_operations.dart';
import '../widget/game_board.dart';

/// @author : Jibin K John
/// @date   : 26/03/2024
/// @time   : 14:58:28

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _nameController.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(.35),
              BlendMode.multiply,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomAppBar(title: 'Create Game'),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomTextField(
                          controller: _nameController,
                          textFieldKey: "name",
                          isObscure: false,
                          hintText: "Player name",
                          inputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
                          borderRadius: 15.0,
                        ),
                      ),
                      const GameBoard(),
                    ],
                  ),
                ),

                // Host button
                ValueListenableBuilder(
                  valueListenable: _loading,
                  builder: (ctx, loading, _) {
                    return AnimatedButton(
                      width: size.width * .8,
                      height: 60.0,
                      title: Text(
                        loading ? "Hosting" : "Host Game",
                        style: TextStyle(
                          color: loading ? Colors.white54 : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      onPressed: loading ? () {} : _onHost,
                      isBoxShadow: true,
                      bgColor: Colors.blue,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHost() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    if (_nameController.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackBar(context, "Please enter a name");
    } else if (provider.containsZero) {
      CustomSnackBar.showErrorSnackBar(
          context, "Please configure your bingo table");
    } else {
      _loading.value = true;
      final roomId = GameOperations.generateRandomWord();
      GameOperations.createGame(
        hostName: _nameController.text.trim(),
        roomId: roomId,
      ).then((response) {
        if (response.isEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameScreen(
                roomId: roomId,
                playerName: _nameController.text.trim(),
              ),
            ),
          );
        } else {
          _loading.value = false;
          CustomSnackBar.showErrorSnackBar(context, response);
        }
      });
    }
  }
}
