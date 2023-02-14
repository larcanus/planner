import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:planner/src/planner/state_manager/step_model.dart';

import '../../constants.dart';
import '../../flame_componets/step_line.dart';
import '../../flame_componets/step_rectangle.dart';
import '../../flame_componets/step_text_box.dart';
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
      appBar: AppBar(title: Text(plan.planeName)),
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
        'buttonMoveRoot': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  FloatingActionButton(
                    heroTag: 'btn4',
                    onPressed: () {
                      game.camera.zoom = 1;
                      game.moveRootStep(force: true);
                    },
                    backgroundColor: Colors.amber,
                    child: const Icon(size: 25, Icons.start_sharp),
                  ),
                ]))
          ]);
        },
        'buttonRevert': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 160, 10, 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                    heroTag: 'btn5',
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
        'buttonZoomMin': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                    heroTag: 'btn6',
                    onPressed: () {
                      print('zoom ${game.camera.zoom}');
                      if (game.camera.zoom >= 0.26) {
                        var gameSizeBefore = game.camera.gameSize;
                        game.camera.zoom -= 0.05;
                        var gameSizeAfter = game.camera.gameSize;
                        var deltaSize = gameSizeAfter - gameSizeBefore;
                        print('deltaX ${deltaSize}');

                        game.camera.translateBy(-deltaSize / 2);
                        game.camera.snap();
                      }
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(size: 25, Icons.zoom_out),
                  ),
                ]))
          ]);
        },
        'buttonZoomMax': (BuildContext context, MyGame game) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 80, 10, 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                    heroTag: 'btn7',
                    onPressed: () {
                      if (game.camera.zoom <= 1.55) {
                        var gameSizeBefore = game.camera.gameSize;
                        game.camera.zoom += 0.05;
                        var gameSizeAfter = game.camera.gameSize;
                        var deltaSize = gameSizeAfter - gameSizeBefore;
                        print('deltaX ${deltaSize}');

                        game.camera.translateBy(-deltaSize / 2);
                        game.camera.snap();
                      }
                      print('button.zoom ${game.camera.zoom}');
                      print('button.position ${game.camera.position}');
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(size: 25, Icons.zoom_in),
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
    planController.componentsInGame = [];
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
    Map<String, dynamic> settings = planController.settings;
    if (settings['isShowButtonsScale']) {
      overlays.add('buttonZoomMax');
      overlays.add('buttonZoomMin');
    }

    overlays.add('buttonMoveRoot');
    moveRootStep(force: true);
  }

  void moveRootStep({force = false}) {
    StepModel root = planController.getRootStep();
    planController.selectStepById(id: root.id, force: force);
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(0.25, 1.55);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    print('zoom currentScale. ${info.scrollDelta.game.y.sign}');
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
      print('camera.zoom ${camera.zoom}');
      // print('zoom startZoom ${startZoom}');
      // print('zoom currentScale. ${ currentScale}');
      double targetZoom = startZoom * currentScale.y;
      if (startZoom <= 1.7 && startZoom >= 0.20) {
        var gameSizeBefore = camera.gameSize;
        camera.zoom = startZoom * targetZoom;
        clampZoom();
        var gameSizeAfter = camera.gameSize;
        var deltaSize = gameSizeAfter - gameSizeBefore;
        camera.translateBy(-deltaSize / 2);
        camera.snap();
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
    camera.worldBounds =
        Rect.fromLTWH(-100, worldTop, worldWidth * 2, worldHeight * 4);
    // print('worldTop ${worldTop}');
    // print('worldWidth ${worldWidth}');
    // print('worldHeight $worldHeight');
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
    StepRectangle step = StepRectangle(
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
      positionStart: isRootStep
          ? Vector2(0, 0)
          : getPosLineStart({
              'width': parent.width,
              'height': parent.height,
              'type': parent.type
            }, getGlobalPosStep(parent)),
      positionEnd: isRootStep
          ? Vector2(0, 0)
          : getPosLineEnd({
              'width': stepData.width,
              'height': stepData.height,
              'type': stepData.type
            }, getGlobalPosStep(parent), gVectorPosStep),
    );
    add(stepLine);
    planController.componentsInGame.add(stepLine);

    // добавляем текст форму с сокращенным описанием шага
    // var gPosTextX = gVectorPosStep.x + step.width / 2;
    // var gPosTextY = gVectorPosStep.y + step.height / 2;
    //
    // Vector2 gVectorPosText = Vector2(gPosTextX, gPosTextY);
    TextComponent textStep = TextBoxStep(stepData.name, gVectorPosStep,
        stepData.background, Vector2(step.width, step.height),STEP_TEXT_BOX_FONT_SIZE);

    add(textStep);

    planController.componentsInGame.add(textStep);
  }

  Vector2 getGlobalPosStep(stepData) {
    bool isRootStep =
        stepData.gPosition['x'] == 500.0 && stepData.gPosition['y'] == 500.0;
    var posX = isRootStep
        ? planController.canvasSizeDefault.x / 2 - stepData.width / 2 + 500
        : planController.canvasSizeDefault.x / 2 +
            stepData.gPosition['x']! +
            500;
    var posY = isRootStep
        ? planController.canvasSizeDefault.y / 2 - stepData.height / 2 + 1200
        : planController.canvasSizeDefault.y / 2 +
            stepData.gPosition['y']! +
            1200;

    setWorldBoundsMax(posX, posY);
    return Vector2(posX, posY);
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