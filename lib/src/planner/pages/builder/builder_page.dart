import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:planner/src/planner/state_manager/step_model.dart';

import '../../constants.dart';
import '../../utils.dart';
import '../plans_list/confirm_dlg.dart';
import 'builder_add_edit_step_dlg.dart';

class BuilderPage extends StatelessWidget {
  final int selectPlanId;

  const BuilderPage({Key? key, required this.selectPlanId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlanController planListController = Get.find();
    PlanItemListModel plan = planListController.getItemPlanById(selectPlanId);
    planListController.selectedPlan = plan;
    imageCache.clear();

    return Scaffold(
      appBar: AppBar(title: Text(plan.planeDesc)),
      body: GameWidget(game: MyGame(plan), overlayBuilderMap: {
        'buttonsStep': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                margin: const EdgeInsets.all(23),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'btn1',
                        onPressed: () {
                          game.overlays.add('deleteStepOverlay');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 28, Icons.delete),
                      ),
                      FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {
                          game.overlays.add('editStepOverlay');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 35, Icons.edit_note),
                      ),
                      FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          game.overlays.add('addStepOverlay');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 35, Icons.add),
                      ),
                    ]))
          ]);
        },
        'buttonRevert': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'btn0',
                        onPressed: () {
                          planListController.recoveryTree();
                          game.refreshTree();
                          game.overlays.remove('buttonRevert');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 25, Icons.replay),
                      ),
                    ]))
          ]);
        },
        'buttonZoom': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          if(game.camera.zoom >= 0.2){
                            game.camera.zoom -= 0.05;
                          }
                          print('game.camera.zoom ${game.camera.zoom}');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 25, Icons.zoom_in_map_outlined),
                      ),
                    ]))
          ]);
        },
        'deleteStepOverlay': (BuildContext context, MyGame game) {
          return ConfirmDlg(
              key: UniqueKey(),
              title: ALARM,
              description: CONFIRM_DELETE_STEP,
              callbackOk: () {
                game.overlays.remove('deleteStepOverlay');
                planListController.selectedStep = null;
                planListController.deleteStepByIdFromTree();
                game.refreshTree();
                planListController.deleteStepByIdFromComponentsCash();
                game.overlays.remove('buttonsStep');
                game.overlays.add('buttonRevert');
              },
              callbackCancel: () {
                game.overlays.remove('deleteStepOverlay');
              });
        },
        'editStepOverlay': (BuildContext context, MyGame game) {
          StepModel selectedStepModel = planListController.selectedStepModel;
          return StepEditDlg(
            key: UniqueKey(),
            game: game,
            stepId: selectedStepModel.id,
            title: EDIT_STEP_TITLE_DLG,
            name: selectedStepModel.name,
            description: selectedStepModel.description,
            background: selectedStepModel.background,
          );
        },
        'addStepOverlay': (BuildContext context, MyGame game) {
          return StepEditDlg(
            key: UniqueKey(),
            game: game,
            title: ADD_STEP_TITLE_DLG,
          );
        },
      }),
    );
  }
}

class MyGame extends FlameGame
    with HasTappables, ScrollDetector, ScaleDetector {
  PlanItemListModel plan;
  static const zoomPerScrollUnit = 0.02;
  late double startZoom;
  late double worldWidth = size.x;
  late double worldHeight = size.y;
  late double worldTop = -100;
  final PlanController planController = Get.find();

  MyGame(this.plan);

  @override
  Color backgroundColor() => DEFAULT_BACKGROUND_BUILDER;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    camera.speed = 450;
    planController.canvasSizeDefault = Vector2(canvasSize.x, canvasSize.y);
    buildTree();
    // onGameResize(Vector2(1000, 1500));
    // camera.viewport = FixedResolutionViewport(Vector2(400, 700));
    // camera.setRelativeOffset(Anchor.topRight);
    // var s = canvasSize;
    // var d = viewportProjector;
    // var h = projector;
    // var gg = camera.gameSize;
    // var zom = camera.zoom;
    // var zosm = FixedResolutionViewport;
    overlays.add('buttonZoom');
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(0.2, 1.5);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    print('zoom currentScale. ${ info.scrollDelta.game.y.sign}');
    camera.zoom += info.scrollDelta.game.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  @override
  void onScaleStart(info) {
    startZoom = camera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      // print('camera.zoom ${camera.zoom}');
      // print('zoom startZoom ${startZoom}');
      // print('zoom currentScale. ${ currentScale}');
      double targetZoom = startZoom * currentScale.y;
      if( startZoom < 1.4 && startZoom > 0.2 ){
        camera.zoom = startZoom * targetZoom;
        clampZoom();
      }
    } else {
      // print('info.delta ${ info.delta}');
      // print('zoom -info.delta.game. ${ -info.delta.global}');
      camera.translateBy(-info.delta.global);
      camera.snap();
    }

  }

  void buildTree() {
    dropWorldBounds();
    // добавляем рута
    createStep(plan.tree);
    buildBranch(plan.tree.childs);
    camera.worldBounds = Rect.fromLTWH(-100, worldTop, worldWidth * 2, worldHeight * 4);
    // print('worldTop ${worldTop}');
    // print('worldWidth ${worldWidth}');
    // print('worldHeight $worldHeight');
    camera.moveTo(Vector2(1000,1000));
    camera.snap();
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

  void createStep(StepModel stepData) {
    var parent = planController.getStepById(stepData.parentId);
    Vector2 gVectorPosStep = getGlobalPosStep(stepData);
    bool isRootStep =
        stepData.gPosition['x'] == 500.0 && stepData.gPosition['y'] == 500.0;

    // добавляем шаг
    Step step = Step(
      id: stepData.id,
      squareWidth: stepData.width,
      squareHeight: stepData.height,
      position: gVectorPosStep,
      camera: camera,
    );
    add(step);
    planController.componentsInGame.add(step);

    // добавляем линию связи шагов
    StepLine stepLine = StepLine(
      parentPosition: isRootStep ? Vector2(0, 0) : getGlobalPosStep(parent),
      positionStart: isRootStep
          ? Vector2(0, 0)
          : getPosLineStart(parent, getGlobalPosStep(parent)),
      positionEnd: isRootStep
          ? Vector2(0, 0)
          : getPosLineEnd(stepData, getGlobalPosStep(parent), gVectorPosStep),
    );
    add(stepLine);
    planController.componentsInGame.add(stepLine);

    // добавляем текст форму с сокращенным описанием шага
    // var gPosTextX = gVectorPosStep.x + step.width / 2;
    // var gPosTextY = gVectorPosStep.y + step.height / 2;
    //
    // Vector2 gVectorPosText = Vector2(gPosTextX, gPosTextY);
    TextComponent textStep = TextBoxStep(stepData.name, gVectorPosStep,
        stepData.background, Vector2(step.width, step.height));

    add(textStep);

    planController.componentsInGame.add(textStep);
  }

  Vector2 getGlobalPosStep(stepData) {
    bool isRootStep =
        stepData.gPosition['x'] == 500.0 && stepData.gPosition['y'] == 500.0;
    var posX = isRootStep
        ? planController.canvasSizeDefault.x / 2 - stepData.width / 2 + 500
        : planController.canvasSizeDefault.x / 2 + stepData.gPosition['x']! + 500;
    var posY = isRootStep
        ? planController.canvasSizeDefault.y / 2 - stepData.height / 2 + 1200
        : planController.canvasSizeDefault.y / 2 + stepData.gPosition['y']! + 1200;

    setWorldBoundsMax(posX, posY);
    return Vector2(posX, posY);
  }

  Vector2 getPosLineStart(dataStep, pos) {
    double xPosCenter = pos.x + dataStep.width;
    double yPosCenter = pos.y + dataStep.height / 2;
    if (dataStep.type == STEP_TYPE_CIRCLE) {
      yPosCenter = 0;
    }

    return Vector2(xPosCenter, yPosCenter);
  }

  Vector2 getPosLineEnd(dataStep, posParent, posChild) {
    double difX = posChild.x - posParent.x - dataStep.width;
    double difY = posChild.y - posParent.y;
    double xPosCenter = dataStep == null ? 0 : difX;
    double yPosCenter = dataStep == null ? 0 : difY;
    if (dataStep?.type == STEP_TYPE_CIRCLE) {
      yPosCenter = 0;
    }
    return Vector2(xPosCenter, yPosCenter);
  }

  void refreshTree() {
    var allComponents = planController.componentsInGame;
    allComponents.forEach((comp) {
      comp.removeFromParent();
    });
    buildTree();
  }

  void setWorldBoundsMax(width, height) {
    var newWidth = width + 500;
    var newHeight = height + 600;
    worldWidth = newWidth > worldWidth ? newWidth : worldWidth;
    worldHeight = newHeight > worldHeight ? newHeight : worldHeight;
    if (height.isNegative) {
      print(height);
    }
    if (height < worldTop) {
      worldTop = height - 100;
      worldHeight += (height - worldTop) * 3.8;
      worldHeight += 60;
    }
  }

  void dropWorldBounds() {
    worldTop = -100;
    worldWidth = planController.canvasSizeDefault.x;
    worldHeight = planController.canvasSizeDefault.y;
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    // print('widget----${info.eventPosition.widget}');
    // print('global---${info.eventPosition.global}');
    // print('game---${info.eventPosition.game}');
    // print('camera.position gg ---- ${camera.position}');
    // print('canvas x y === ${canvasSize.x} ${canvasSize.y}');
    if (overlays.isActive('addStepOverlay')) {
      overlays.remove('addStepOverlay');
    }
    if (overlays.isActive('editStepOverlay')) {
      overlays.remove('editStepOverlay');
    }
  }
}

class Step extends PositionComponent with Tappable {
  int id;
  double squareWidth = 100.0;
  double squareHeight = 100.0;
  Camera camera;
  final PlanController planController = Get.find();

  Step(
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

  void selectStep() {
    final touchPoint = Vector2(0, 0);
    Vector2 sizeTools = Vector2(squareWidth, squareHeight);
    double posWidgetGlobalX = position.x + squareWidth / 2;
    double posWidgetGlobalY = position.y + squareHeight / 2;
    Vector2 centerWidgetScreenPos = Vector2(
        posWidgetGlobalX - planController.canvasSizeDefault.x / 2,
        posWidgetGlobalY - planController.canvasSizeDefault.y / 2);
    camera.moveTo(centerWidgetScreenPos);
    StepTools stepTools = StepTools(position: touchPoint, size: sizeTools);
    add(stepTools);

    final selectedStepTools = planController.selectedStepTools;
    if (selectedStepTools != null) {
      selectedStepTools.removeFromParent();
    }
    planController.selectedStepTools = stepTools;
    planController.selectedStep = this;
    planController.selectedStepModel = planController.getStepById(id);
  }

  void handlerButtonsStep() {
    Game? game = findGame();
    var over = game?.overlays;
    Step? selectedStep = planController.selectedStep;
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
    Vector2 centerWidgetScreenPos = Vector2(
        posWidgetGlobalX - camera.canvasSize.x / 2,
        posWidgetGlobalY - camera.canvasSize.y / 2);
    camera.moveTo(centerWidgetScreenPos);

    return true;
  }

  @override
  String toString() {
    return 'Step';
  }
}

class StepLine extends PositionComponent {
  Vector2 parentPosition;
  Vector2 positionStart;
  Vector2 positionEnd;
  Paint stylePaint = Paint()
    ..strokeWidth = STROKE_BORDER_STEP_TOOLS
    ..style = PaintingStyle.stroke
    ..color = COLOR_LINE_BRANCH_STEPS
    ..strokeWidth = 2;
  final Path _path = Path();

  StepLine(
      {required this.parentPosition,
      required this.positionStart,
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

class StepTools extends PositionComponent with Tappable {
  Paint stylePaint = Paint();

  StepTools({required Vector2 position, required Vector2 size})
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

class TextBoxStep extends TextBoxComponent {
  String background;

  TextBoxStep(
    String text,
    Vector2 position,
    this.background,
    size, {
    double? timePerChar,
    double? margins,
  }) : super(
          position: position,
          text: text,
          size: size,
          align: Anchor.center,
          textRenderer: TextPaint(
              style: const TextStyle(
            fontSize: 18,
            color: COLOR_NAME_STEP,
          )),
          boxConfig: TextBoxConfig(
            maxWidth: 180,
            growingBox: true,
            margins: EdgeInsets.all(margins ?? 25),
          ),
        );

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = HexColor.fromHex(background));
    super.render(c);
  }
}
