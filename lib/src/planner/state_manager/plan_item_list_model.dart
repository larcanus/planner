import 'package:planner/src/planner/state_manager/step_model.dart';

class PlanItemListModel {
  int id;
  String planeName;
  String planeDesc;
  int backgroundColor;
  bool isActive;
  int activeStep;
  StepModel tree;

  PlanItemListModel(
      {required this.id,
      required this.planeName,
      required this.planeDesc,
      required this.backgroundColor,
      required this.tree,
      required this.activeStep,
      this.isActive = false
      });

  PlanItemListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        planeName = json['planeName'],
        planeDesc = json['planeDesc'],
        backgroundColor = json['backgroundColor'],
        tree = json['tree'],
        activeStep = json['activeStep'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'planeName': planeName,
        'planeDesc': planeDesc,
        'backgroundColor': backgroundColor,
        'tree': tree,
        'activeStep': activeStep,
        'isActive': isActive,
      };
}
