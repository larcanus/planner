import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:planner/src/planner/state_manager/step_model.dart';

import '../../constants.dart';
import '../../state_manager/plan_controller.dart';
import '../../state_manager/plan_item_list_model.dart';
import '../../state_manager/plan_tree_model.dart';

class CurrentPlanTree extends StatelessWidget {
  const CurrentPlanTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: TreeActiveStep());
  }
}

class TreeActiveStep extends FlameGame with HasTappables {
  final PlanController planController = Get.find();

  @override
  Color backgroundColor() => DEFAULT_BACKGROUND_BUILDER;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    buildTree();
  }

  void buildTree() {
    var activePlan = planController.currentActivePlan;
    var tree = activePlan.tree;
    if (tree != null) {
      setActiveStep(tree);
    } else {
      Plug();
    }
  }

  setActiveStep(StepModel activeStep) {
    Vector2 centerPos = Vector2(canvasSize.x / 2, canvasSize.y / 2);

    if (activeStep.type == STEP_TYPE_RECT) {
      centerPos = Vector2(canvasSize.x / 2 - activeStep.width / 2 / STEP_DECREASE_COF,
          canvasSize.y / 2 - activeStep.height / 2 / STEP_DECREASE_COF);
    }

    Step step = Step(
      id: activeStep.id,
      squareWidth: activeStep.width / STEP_DECREASE_COF,
      squareHeight: activeStep.height / STEP_DECREASE_COF,
      position: centerPos,
      camera: camera,
    );
    add(step);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    // print('widget----${info.eventPosition.widget}');
    // print('global---${info.eventPosition.global}');
    print('game---${info.eventPosition.game}');
    // print('camera.position gg ---- ${camera.position}');
    print('canvas x y === ${canvasSize.x} ${canvasSize.y}');
  }
}

class Step extends PositionComponent with Tappable {
  int id;
  double squareWidth = 100.0;
  double squareHeight = 100.0;
  Camera camera;

  Step(
      {required this.id,
      required Vector2 position,
      required this.squareWidth,
      required this.squareHeight,
      required this.camera})
      : super(position: position);
  static Paint black = BasicPalette.black.paint();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), black);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareWidth, squareHeight);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    print('stepPosition.x----${position}');
    return true;
  }

  @override
  String toString() {
    return 'Step';
  }
}

class Plug extends PositionComponent {}
