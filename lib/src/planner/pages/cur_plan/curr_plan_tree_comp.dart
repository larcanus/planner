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
    if (activePlan != null) {
      StepModel activeStep = getActiveStep(activePlan);
      if (activeStep != null) {
        planController.currentActiveStep = activeStep;
        drawActiveStep(activeStep);
        drawLastSteps(getLastSteps(activeStep));
        drawNextSteps(getNextSteps(activeStep));
      } else {
        Plug();
      }
    } else {
      Plug();
    }
  }

  drawActiveStep(StepModel activeStep) {
    Vector2 centerPos = Vector2(canvasSize.x / 2, canvasSize.y / 2);

    if (activeStep.type == STEP_TYPE_RECT) {
      centerPos = Vector2(
          canvasSize.x / 2 - activeStep.width / 2 / STEP_DECREASE_ACTIVE_COF,
          canvasSize.y / 2 - activeStep.height / 2 / STEP_DECREASE_ACTIVE_COF);
    }

    Step step = Step(
      id: activeStep.id,
      squareWidth: activeStep.width / STEP_DECREASE_ACTIVE_COF,
      squareHeight: activeStep.height / STEP_DECREASE_ACTIVE_COF,
      position: centerPos,
      camera: camera,
    );
    add(step);
  }

  StepModel getActiveStep(PlanItemListModel tree) {
    return planController.getStepById(tree.activeStep);
  }

  List<StepModel> getLastSteps(StepModel step) {
    if (step.parentId == 0) {
      return [];
    } else {
      return [planController.getStepById(step.parentId)];
    }
  }

  List getNextSteps(StepModel step) {
    return step.childs;
  }

  drawLastSteps(List lastSteps) {
    for (var step in lastSteps) {
      Step newStep = Step(
        id: step.id,
        squareWidth: step.width / STEP_DECREASE_CHILD_COF,
        squareHeight: step.height / STEP_DECREASE_CHILD_COF,
        position: Vector2(100, 100),
        camera: camera,
      );
      add(newStep);
    }
  }

  drawNextSteps(List nextSteps) {
    List<List<double>> listPos = planController.getPositionNextStep(
        nextSteps.length, canvasSize.x, canvasSize.y);
    for (int i = 0; i < nextSteps.length; i++) {
      var step = nextSteps[i];
      var pos = listPos[i];
      Vector2 position = Vector2(pos[0] - step.width / STEP_DECREASE_CHILD_COF / 2,
          pos[1] - step.height / STEP_DECREASE_CHILD_COF / 2);
      Step newStep = Step(
        id: step.id,
        squareWidth: step.width / STEP_DECREASE_CHILD_COF,
        squareHeight: step.height / STEP_DECREASE_CHILD_COF,
        position: position,
        camera: camera,
      );
      add(newStep);
    }
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
