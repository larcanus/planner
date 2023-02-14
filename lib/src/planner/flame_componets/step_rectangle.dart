import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/flame_componets/step_border.dart';
import '../state_manager/plan_controller.dart';

class StepRectangle extends PositionComponent with Tappable {
  int id;
  double squareWidth = 100.0;
  double squareHeight = 100.0;
  Camera camera;
  final PlanController planController = Get.find();

  StepRectangle(
      {required this.id,
      required Vector2 position,
      required this.squareWidth,
      required this.squareHeight,
      required this.camera})
      : super(position: position);
  static Paint white = BasicPalette.white.paint();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), white);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareWidth, squareHeight);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    planController.selectedStep = null;
    // print('parentPosition.x----${parentPosition}');
    // print('stepPosition.x----${position}');

    if (!info.handled) {
      selectStep();
    }
    handlerButtonsStep();
    return true;
  }

  void selectStep({force = false}) {
    double posWidgetGlobalX = position.x + squareWidth / 2;
    double posWidgetGlobalY = position.y + squareHeight / 2;

    Vector2 centerWidgetScreenPos2 = Vector2(
        posWidgetGlobalX - camera.gameSize[0] / 2,
        posWidgetGlobalY - camera.gameSize[1] / 2);
    camera.moveTo(centerWidgetScreenPos2);
    if (force) {
      camera.snap();
    }

    handlerBorder();
    planController.selectedStep = this;
    planController.selectedStepModel = planController.getStepById(id);
  }

  handlerBorder() {
    Vector2 touchPoint = Vector2(0, 0);
    Vector2 sizeTools = Vector2(squareWidth, squareHeight);
    StepBorder stepBorder = StepBorder(position: touchPoint, size: sizeTools);
    add(stepBorder);

    dynamic selectedStepBorder = planController.selectedStepBorder;
    if (selectedStepBorder != null) {
      selectedStepBorder.removeFromParent();
    }
    planController.selectedStepBorder = stepBorder;
  }

  void handlerButtonsStep() {
    Game? game = findGame();
    var over = game?.overlays;
    StepRectangle? selectedStep = planController.selectedStep;
    if (over != null && selectedStep != null) {
      over.add('buttonsStep');
    } else {
      if (over != null && over.isActive('buttonsStep')) {
        over.remove('buttonsStep');
      }
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    double posWidgetGlobalX = position.x + squareWidth / 2;
    double posWidgetGlobalY = position.y + squareHeight / 2;
    Vector2 centerWidgetScreenPos2 = Vector2(
        posWidgetGlobalX - camera.gameSize[0] / 2,
        posWidgetGlobalY - camera.gameSize[1] / 2);
    camera.moveTo(centerWidgetScreenPos2);

    return true;
  }

  @override
  String toString() {
    return 'StepRectangle';
  }
}

class StepRectangleFrontPage extends StepRectangle {
  StepRectangleFrontPage(
      {required id,
      required Vector2 position,
      required squareWidth,
      required squareHeight,
      required camera})
      : super(
            id: id,
            squareWidth: squareWidth,
            squareHeight: squareHeight,
            camera: camera,
            position: position);
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
    print('stepPosition.x----${position}');

    int idActiveStep = planController.currentActiveStep.id;
    planController.selectedStep = this;
    planController.setStepModelById(id);
    info.handled = true;

    if (id != idActiveStep) {
      handlerStepInfoOverlay(show: true);
      handlerBtnActOverlay(show: true);
    } else {
      handlerStepInfoOverlay(show: true);
      handlerBtnActOverlay(show: false);
    }

    handlerBorder();

    return true;
  }

  handlerStepInfoOverlay({bool show = true}) {
    Game? game = findGame();
    var over = game?.overlays;
    if (over != null) {
      if (over.isActive('stepInfo')) {
        over.remove('stepInfo');
      }
      if (show) {
        over.add('stepInfo');
      }
    }
  }


  handlerBtnActOverlay({bool show = true}) {
    Game? game = findGame();
    var over = game?.overlays;
    if (over != null) {
      if (over.isActive('buttonActivate')) {
        over.remove('buttonActivate');
      }
      if (show) {
        over.add('buttonActivate');
      }
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }

  @override
  String toString() {
    return 'StepRectangle';
  }
}
