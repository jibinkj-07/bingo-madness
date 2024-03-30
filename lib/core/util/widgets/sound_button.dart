import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../features/settings/presentation/provider/setting_provider.dart';
import 'animated_button.dart';

class SoundButton extends StatelessWidget {
  final Color? color;
  const SoundButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (ctx, provider, _) {
        return AnimatedButton(
          width: 50.0,
          height: 50.0,
          title: Icon(
            provider.appSound
                ? Icons.music_note_rounded
                : Icons.music_off_rounded,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Provider.of<SettingProvider>(context, listen: false).appSound =
                !provider.appSound;
          },
          isBoxShadow: false,
          bgColor:color?? Colors.amber,
        );
      },
    );
  }
}
