import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:planner/src/planner/state_manager/plan_tree_model.dart';

import '../../constants.dart';
import 'builder_add_step_dlg.dart';

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
                        onPressed: () {},
                        backgroundColor: Colors.green,
                        child: const Icon(size: 28, Icons.delete),
                      ),
                      FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {},
                        backgroundColor: Colors.green,
                        child: const Icon(size: 35, Icons.edit_note),
                      ),
                      FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          print(this);
                          print(game);
                          // game.buildTree();
                          game.overlays.add('addStepOverlay');
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(size: 35, Icons.add),
                      ),
                    ]))
          ]);
        },
        'addStepOverlay': (BuildContext context, MyGame game) {
          return StepEditDlg(key: UniqueKey(), game: game);
        }
      }),
    );
  }
}

class MyGame extends FlameGame
    with HasTappables, ScrollDetector, ScaleDetector {
  PlanItemListModel plan;
  late double worldWidth = size.x;
  late double worldHeight = size.y;

  MyGame(this.plan);

  @override
  Color backgroundColor() => const Color(0xffD3D3D3);

  @override
  Future<void> onLoad() async {
    // onGameResize(Vector2(1000, 1500));
    buildTree();
    // camera.viewport = FixedResolutionViewport(Vector2(400, 700));
    // camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;
    // camera.worldBounds = Rect.fromLTWH(0, 0, worldWidth, worldHeight);
    // var s = canvasSize;
    // var d = viewportProjector;
    // var h = projector;

    // var gg = camera.gameSize;
    // var zom = camera.zoom;
    // var zosm = FixedResolutionViewport;
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

  void buildTree() {
    // готовое дерево из трех шагов
    plan.tree = PlanTreeModel(
        id: 11,
        name: 'node root',
        parentId: 0,
        width: 140,
        height: 100,
        type: STEP_TYPE_RECT,
        gPosition: {
          'x': 0,
          'y': 0
        },
        childs: [
          PlanTreeModel(
            id: 112,
            name: 'Branch 1 node 1',
            parentId: 11,
            width: 140,
            height: 105,
            type: STEP_TYPE_RECT,
            gPosition: {'x': 150, 'y': 80},
            childs: [
              PlanTreeModel(
                id: 1121,
                name: 'Branch 1-1 node 1-1',
                parentId: 112,
                width: 140,
                height: 105,
                type: STEP_TYPE_RECT,
                gPosition: {'x': 340, 'y': 220},
                childs: [],
              ),
              PlanTreeModel(
                id: 1122,
                name: 'Branch 1-2 node 2-1',
                parentId: 112,
                width: 140,
                height: 105,
                type: STEP_TYPE_RECT,
                gPosition: {'x': 340, 'y': 90},
                childs: [],
              )
            ],
          ),
          PlanTreeModel(
            id: 113,
            name: 'Branch 2 node 1',
            parentId: 11,
            width: 140,
            height: 105,
            type: STEP_TYPE_RECT,
            gPosition: {'x': 150, 'y': -80},
            childs: [
              PlanTreeModel(
                id: 114,
                name: 'Branch 2-1 node 1-2',
                parentId: 113,
                width: 140,
                height: 105,
                type: STEP_TYPE_RECT,
                gPosition: {'x': 350, 'y': -80},
                childs: [],
              )
            ],
          ),
        ]);
    // добавляем рута
    createStep(plan.tree);
    buildBranch(plan.tree.childs);
    camera.worldBounds = Rect.fromLTWH(0, 0, worldWidth, worldHeight);
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
    final PlanController planController = Get.find();
    var parent = planController.getStepById(stepData.parentId);
    Vector2 gVectorPosStep = getGlobalPosStep(stepData);
    bool isRootStep =
        stepData.gPosition['x'] == 0 && stepData.gPosition['y'] == 0;

    // print('stepData.parentId  ${stepData.parentId}');
    // print('parent  ${parent}');

    // добавляем шаг
    Step step = Step(
      squareWidth: stepData.width,
      squareHeight: stepData.height,
      position: gVectorPosStep,
      camera: camera,
    );
    add(step);

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

    // добавляем текст форму с сокращенным описанием шага
    final regularTextStyle =
        TextStyle(fontSize: 18, color: BasicPalette.green.color);
    final regular = TextPaint(style: regularTextStyle);
    var gPosTextX = gVectorPosStep.x + step.width / 2;
    var gPosTextY = gVectorPosStep.y + step.height / 2;

    Vector2 gVectorPosText = Vector2(gPosTextX, gPosTextY);
    add(TextComponent(
        text: stepData.name,
        textRenderer: regular,
        anchor: Anchor.center,
        position: gVectorPosText));
  }

  Vector2 getGlobalPosStep(stepData) {
    bool isRootStep =
        stepData.gPosition['x'] == 0 && stepData.gPosition['y'] == 0;
    var posX = isRootStep
        ? size.x / 2 - stepData.width / 2
        : size.x / 2 + stepData.gPosition['x']!;
    var posY = isRootStep
        ? size.y / 2 - stepData.height / 2
        : size.y / 2 + stepData.gPosition['y']!;

    setWorldBoundsMax(posX + 400, posY + 400);
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

  setWorldBoundsMax(width, height) {
    worldWidth = width > worldWidth ? width : worldWidth;
    worldHeight = height > worldHeight ? height : worldHeight;
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    print('widget----${info.eventPosition.widget}');
    print('global---${info.eventPosition.global}');
    print('game---${info.eventPosition.game}');
    // print('camera.position gg ---- ${camera.position}');
    if (overlays.isActive('addStepOverlay')) {
      overlays.remove('addStepOverlay');
    }
  }
}

class Step extends PositionComponent with Tappable {
  double squareWidth = 100.0;
  double squareHeight = 100.0;
  Camera camera;
  final PlanController planController = Get.find();

  Step(
      {required Vector2 position,
      required this.squareWidth,
      required this.squareHeight,
      required this.camera})
      : super(position: position);
  static Paint white = BasicPalette.white.paint();

  get overlays => null;

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
      final touchPoint = Vector2(0, 0);
      Vector2 sizeTools = Vector2(squareWidth, squareHeight);
      double posWidgetGlobalX = position.x + squareWidth / 2;
      double posWidgetGlobalY = position.y + squareHeight / 2;
      Vector2 centerWidgetScreenPos = Vector2(
          posWidgetGlobalX - camera.canvasSize.x / 2,
          posWidgetGlobalY - camera.canvasSize.y / 2);
      camera.speed = 450;
      camera.moveTo(centerWidgetScreenPos);
      StepTools stepTools = StepTools(position: touchPoint, size: sizeTools);
      add(stepTools);

      final selectedStepTools = planController.selectedStepTools;
      if (selectedStepTools != null) {
        selectedStepTools.removeFromParent();
      }
      planController.selectedStepTools = stepTools;
      planController.selectedStep = this;
    }
    handlerButtonsStep();
    return true;
  }

  handlerButtonsStep() {
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
    camera.speed = 450;
    camera.moveTo(centerWidgetScreenPos);

    return true;
  }
}

class StepLine extends PositionComponent {
  Vector2 parentPosition;
  Vector2 positionStart;
  Vector2 positionEnd;
  Paint stylePaint = Paint();
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
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    buildPath();

    stylePaint
      ..strokeWidth = STROKE_BORDER_STEP_TOOLS
      ..style = PaintingStyle.stroke
      ..color = COLOR_BORDER_STEP_TOOLS
      ..strokeWidth = 2;

    canvas.drawPath(_path, stylePaint);
  }

  buildPath() {
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
