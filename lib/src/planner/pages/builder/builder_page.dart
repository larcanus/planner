import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:planner/src/planner/state_manager/plan_tree_model.dart';

class BuilderPage extends StatelessWidget {
  final int selectPlanId;

  const BuilderPage({Key? key, required this.selectPlanId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlanController planList = Get.find();
    PlanItemListModel plan = planList.getItemPlanById(selectPlanId);
    imageCache.clear();

    return Scaffold(
      appBar: AppBar(title: Text(plan.planeDesc)),
      body: GameWidget(
        game: MyGame(plan),
      ),
    );
  }
}

class MyGame extends FlameGame with HasTappables {
  late Size screenSize;
  late double tileSize;
  PlanItemListModel plan;

  MyGame(this.plan);

  @override
  Color backgroundColor() => const Color(0xffD3D3D3);

  @override
  Future<void> onLoad() async {
   Camera();
    buildTree();
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    if (!info.handled) {
      final touchPoint = info.eventPosition.game;
      add(Square(touchPoint));
    }
  }

  void buildTree(){
    plan.tree;
    print(plan.tree);

    if( plan.tree.childIds.isNotEmpty ){
      for (int i = 0; i < plan.tree.childIds.length; i++) {
        createStep(plan.tree);
      }
    } else {
      createStep(plan.tree);
    }
  }

  void createStep(PlanTreeModel tree){
    add(Step());
  }

  void resize(Size size){
    screenSize = size;
    tileSize = screenSize.width / 9;
  }
}

class Step extends PositionComponent with Tappable {
  Step() : super();

  static const squareSize = 128.0;
  static Paint white = BasicPalette.white.paint();
  @override
  Vector2 get absoluteCenter => absolutePositionOfAnchor(Anchor.center);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), white);
    Camera().followComponent(this);
  }

  @override
  void update(double dt) {
    // Camera().update(dt);
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print(info);
    return true;
  }
}




class Square extends PositionComponent with Tappable {
  static const speed = 0.25;
  static const squareSize = 128.0;

  static Paint green = BasicPalette.green.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position) : super(position: position);

  @override
  void render(Canvas c) {
    c.drawRect(size.toRect(), green);
    c.drawRect(const Rect.fromLTWH(0, 0, 3, 3), red);
    c.drawRect(Rect.fromLTWH(width / 2, height / 2, 3, 3), blue);
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    removeFromParent();
    info.handled = true;
    return true;
  }
}