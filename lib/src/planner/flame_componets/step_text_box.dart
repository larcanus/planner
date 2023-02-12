import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils.dart';

class TextBoxStep extends TextBoxComponent {
  String background;

  TextBoxStep(
    String text,
    Vector2 position,
    this.background,
    size,
    fontSize, {
    double? timePerChar,
    double? margins,
  }) : super(
          position: position,
          text: text,
          size: size,
          align: Anchor.center,
          textRenderer: TextPaint(
              style: TextStyle(
                fontSize: fontSize,
            color: COLOR_NAME_STEP,
          )),
          boxConfig: TextBoxConfig(
            maxWidth: 180,
            growingBox: true,
            margins: EdgeInsets.all(margins ?? 15),
          ),
        );

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = HexColor.fromHex(background));
    super.render(c);
  }
}
