import 'dart:ui';
import 'package:flame/components.dart';
import '../constants.dart';

class StepLine extends PositionComponent {
  Vector2 positionStart;
  Vector2 positionEnd;
  Paint stylePaint = Paint()
    ..strokeWidth = STROKE_BORDER_STEP_TOOLS
    ..style = PaintingStyle.stroke
    ..color = COLOR_LINE_BRANCH_STEPS
    ..strokeWidth = 2;
  final Path _path = Path();

  StepLine(
      {required this.positionStart,
        required this.positionEnd})
      : super(position: positionStart);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // print('parentPosition.x----${parentPosition}');
    // print('positionStart.x----${positionStart}');
    // print('positionEnd.x----${positionEnd}');
    buildPath();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawPath(_path, stylePaint);
  }

  void buildPath() {
    _path
      ..moveTo(0, 0)
      ..lineTo(positionEnd.x, positionEnd.y);
  }
}