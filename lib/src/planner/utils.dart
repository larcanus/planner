import 'dart:ui';
import 'package:flame/components.dart';
import 'constants.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length >= 6 || hexString.length <= 10) {
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else {
      return const Color(0xffffffff);
    }
  }

  toHex() {
    return '#${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

Vector2 getPosLineStart(Map dataStep, Vector2 pos) {
  double xPosCenter = pos.x + dataStep['width'];
  double yPosCenter = pos.y + dataStep['height'] / 2;
  if (dataStep['type'] == STEP_TYPE_CIRCLE) {
    yPosCenter = 0;
  }

  return Vector2(xPosCenter, yPosCenter);
}

Vector2 getPosLineEnd(Map dataStep, Vector2 posParent, posChild) {
  double difX = posChild.x - posParent.x - dataStep['width'];
  double difY = posChild.y - posParent.y;
  double xPosCenter = dataStep == null ? 0 : difX;
  double yPosCenter = dataStep == null ? 0 : difY;
  if (dataStep['type'] == STEP_TYPE_CIRCLE) {
    yPosCenter = 0;
  }
  return Vector2(xPosCenter, yPosCenter);
}