import 'package:flutter/material.dart';

const Map<String, ImageProvider> imageMap = {
  'cargillLogo': AssetImage('assets/cargill_logo.png'),
  'provimiChicken': AssetImage('assets/provimi_chicken.png'),
  'provimiColor': AssetImage('assets/provimi_color.png'),
  'provimiDialog': AssetImage('assets/provimi_dialog.jpeg'),
  'provimiDot': AssetImage('assets/provimi_dot.png'),
  'provimiPig': AssetImage('assets/provimi_pig.png'),
  'provimi': AssetImage('assets/provimi.png'),
  'purinaBackground': AssetImage('assets/purina_background.jpeg'),
  'purinaDialog': AssetImage('assets/purina_dialog.png'),
  'purinaPointer': AssetImage('assets/purina_pointer.png'),
  'purinaWheel': AssetImage('assets/purina_wheel.png'),
  'purina': AssetImage('assets/purina.png'),
};

class ImageUtils {
  static void precacheAllAsset(BuildContext context) {
    for (ImageProvider provider in imageMap.values) {
      precacheImage(provider, context);
    }
  }
}
