import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../constants.dart';

class StepBorder extends PositionComponent with Tappable {
  Paint stylePaint = Paint();

  StepBorder({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    stylePaint
      ..strokeWidth = STROKE_BORDER_STEP_TOOLS
      ..style = PaintingStyle.stroke
      ..color = COLOR_BORDER_STEP_TOOLS;
    canvas.drawRect(size.toRect(), stylePaint);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.topLeft;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    removeFromParent();
    info.handled = true;
    return true;
  }
}
