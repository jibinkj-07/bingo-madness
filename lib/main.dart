import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/lobby/presentation/provider/game_provider.dart';
import 'features/lobby/presentation/view/lobby_screen.dart';
import 'features/settings/presentation/provider/setting_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingProvider()),
          ChangeNotifierProvider(create: (_) => GameProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

/// Global variable for sound track
ValueNotifier<AudioPlayer> generalButtonSound = ValueNotifier(AudioPlayer());
ValueNotifier<AudioPlayer> victorySound = ValueNotifier(AudioPlayer());
ValueNotifier<AudioPlayer> failedSound = ValueNotifier(AudioPlayer());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    generalButtonSound.value.setReleaseMode(ReleaseMode.stop);
    generalButtonSound.value.setSourceAsset("sounds/click.wav");

    victorySound.value.setReleaseMode(ReleaseMode.stop);
    victorySound.value.setSourceAsset("sounds/won.mp3");

    failedSound.value.setReleaseMode(ReleaseMode.stop);
    failedSound.value.setSourceAsset("sounds/failed.mp3");

    super.initState();
  }

  @override
  void dispose() {
    generalButtonSound.value.dispose();
    victorySound.value.dispose();
    failedSound.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
        fontFamily: "Signika",
      ),
      home: const LobbyScreen(),
    );
  }
}
