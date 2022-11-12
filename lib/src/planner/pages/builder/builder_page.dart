import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';
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

class MyGame extends FlameGame with HasTappables, ScrollDetector, ScaleDetector {
  PlanItemListModel plan;

  MyGame(this.plan);

  @override
  Color backgroundColor() => const Color(0xffD3D3D3);

  @override
  Future<void> onLoad() async {
    onGameResize(Vector2(1000, 2000));
    buildTree();

    // camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;
    // var s = canvasSize;
    // var d = viewportProjector;
    // var h = projector;

    // var gg = camera.gameSize;
    // var zom = camera.zoom;
    // var zosm = FixedResolutionViewport;
    // camera.zoom = 0.8;
    // camera.moveTo(Vector2(500, 800));
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(0.05, 3.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom += info.scrollDelta.game.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  late double startZoom;

  @override
  void onScaleStart(info) {
    startZoom = camera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      camera.translateBy(-info.delta.game);
      camera.snap();
    }
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    if (!info.handled) {
      final touchPoint = info.eventPosition.game;
      add(Square(touchPoint));
    }
  }

  void buildTree() {
    // готовое дерево из трех шагов
    plan.tree = PlanTreeModel(
        id: 0000000,
        name: 'node root',
        parentId: null,
        gPosition: {
          'x': 50,
          'y': 80
        },
        childs: [
          PlanTreeModel(
            id: 1111111,
            name: 'node 1',
            parentId: 0000000,
            gPosition: {'x': 200, 'y': 80},
            childs: [
              PlanTreeModel(
                id: 2222222,
                name: 'node 2',
                parentId: 1111111,
                gPosition: {'x': 240, 'y': 220},
                childs: [],
              )
            ],
          ),
        ]);

    // добавляем рута
    createStep(plan.tree);
    buildBranch(plan.tree.childs);
  }

  void buildBranch(List childs) {
    if (childs.isNotEmpty) {
      for (int i = 0; i < childs.length; i++) {
        createStep(childs[i]);
        if (childs[i].childs.isNotEmpty) {
          buildBranch(childs[i].childs);
        }
      }
    }
  }

  void createStep(PlanTreeModel stepData) {
    Vector2 gVectorPosStep = Vector2(stepData.gPosition['x']!, stepData.gPosition['y']!);
    var step = Step(position: gVectorPosStep);
    add(step);

    final regularTextStyle =
        TextStyle(fontSize: 18, color: BasicPalette.green.color);
    final regular = TextPaint(style: regularTextStyle);
    var gPosTextX = stepData.gPosition['x']! + step.width / 2;
    var gPosTextY = stepData.gPosition['y']! + step.height / 2;

    Vector2 gVectorPosText = Vector2(gPosTextX, gPosTextY);
    add(TextComponent(
        text: stepData.name,
        textRenderer: regular,
        anchor: Anchor.center,
        position: gVectorPosText));
  }
}

class Step extends PositionComponent with Tappable {
  Step({required Vector2 position}) : super(position: position);

  static const squareSize = 100.0;
  static Paint white = BasicPalette.white.paint();

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), white);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
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
