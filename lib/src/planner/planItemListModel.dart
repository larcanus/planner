class PlanItemListModel {
  int id;
  String planeName;
  String planeDesc;
  int backgroundColor;
  bool isActive;

  PlanItemListModel(
      {required this.id,
      required this.planeName,
      required this.planeDesc,
      required this.backgroundColor,
      this.isActive = false});

  PlanItemListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        planeName = json['planeName'],
        planeDesc = json['planeDesc'],
        backgroundColor = json['backgroundColor'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'planeName': planeName,
        'planeDesc': planeDesc,
        'backgroundColor': backgroundColor,
        'isActive': isActive,
      };
}
