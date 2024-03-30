import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/util/widgets/animated_button.dart';
import '../../../../core/util/widgets/sound_button.dart';
import '../provider/game_provider.dart';
import 'create_screen.dart';
import 'join_screen.dart';

/// @author : Jibin K John
/// @date   : 26/03/2024
/// @time   : 11:58:45

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: const [
          SoundButton(),
          SizedBox(width: 10.0),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/lobby_bg.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(.2),
              BlendMode.multiply,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: size.width * .8,
              ),
              Column(
                children: [
                  AnimatedButton(
                    onPressed: () => _nextScreen(const CreateScreen(), context),
                    title: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    width: size.width * .8,
                    height: size.height * .07,
                    borderRadius: 40.0,
                    bgColor: Colors.blue,
                    isBoxShadow: true,
                  ),
                  const SizedBox(height: 50.0),
                  AnimatedButton(
                    onPressed: () => _nextScreen(const JoinScreen(), context),
                    title: const Text(
                      "Join",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    width: size.width * .65,
                    height: size.height * .07,
                    borderRadius: 50.0,
                    bgColor: Colors.orange,
                    isBoxShadow: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextScreen(Widget screen, BuildContext context) {
    Provider.of<GameProvider>(context, listen: false).resetMatrix();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}
