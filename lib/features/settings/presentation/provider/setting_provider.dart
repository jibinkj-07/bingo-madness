import 'package:flutter/foundation.dart';

class SettingProvider extends ChangeNotifier {
  bool _appSound = true;

  bool get appSound => _appSound;

  set appSound(bool sound) {
    _appSound = sound;
    notifyListeners();
  }

}
