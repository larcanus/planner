import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/planItemListController.dart';
import 'package:planner/src/planner/planItemListModel.dart';
import 'dart:ui' as ui;

class BuilderPage extends StatelessWidget {
  final int selectPlanId;

  const BuilderPage({Key? key, required this.selectPlanId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemListController contItemList = Get.find();
    PlanItemListModel plan = contItemList.getItemPlanById(selectPlanId);

    return Scaffold(
      appBar: AppBar(title: Text(plan.planeDesc)),
      body: Center(
        child: CustomPaint(
          painter: OpenPainter(),
        ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width > 1.0 && size.height > 1.0) {
      print(">1.9");
    }
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.pink
      ..blendMode = BlendMode.colorDodge
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;




    var textPainter = TextPainter(
      text: const TextSpan(
          text: "`12qewasdf`",
          style: TextStyle(color: Colors.red, fontSize: 20)),
      textDirection: TextDirection.rtl,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 2,
    )..layout();
    var startOffset = -150.0;
    canvas.drawRect(
        Rect.fromLTRB(startOffset, startOffset, startOffset + textPainter.width,
            startOffset + textPainter.height),
        paint);
    textPainter.paint(canvas, Offset(startOffset, startOffset));
  }

  // Path generatePath(double x, double y) {
  //   Path path = new Path();
  //   path.moveTo(x, y);
  //   path.lineTo(x + 100, y + 100);
  //   path.lineTo(x + 150, y + 80);
  //   path.lineTo(x + 100, y + 200);
  //   path.lineTo(x, y + 100);
  //   return path;
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
