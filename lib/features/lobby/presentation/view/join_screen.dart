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
/// @time   : 18:02:17

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _nameController.dispose();
    _roomIdController.dispose();
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
                const CustomAppBar(title: 'Join Game'),
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
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          borderRadius: 15.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          controller: _roomIdController,
                          textFieldKey: "roomId",
                          isObscure: false,
                          hintText: "Room id",
                          inputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.characters,
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
                        loading ? "Joining" : "Join Game",
                        style: TextStyle(
                          color: loading ? Colors.black54 : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      onPressed: loading ? () {} : _onJoin,
                      isBoxShadow: true,
                      bgColor: Colors.orange,
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

  void _onJoin() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    if (_nameController.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackBar(context, "Please enter a name");
    } else if (_roomIdController.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackBar(context, "Please enter room id");
    } else if (provider.containsZero) {
      CustomSnackBar.showErrorSnackBar(
          context, "Please configure your bingo table");
    } else {
      _loading.value = true;
      GameOperations.joinGame(
        opponentName: _nameController.text.trim(),
        roomId: _roomIdController.text.trim(),
      ).then((response) {
        if (response.isEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameScreen(
                roomId: _roomIdController.text.trim(),
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
