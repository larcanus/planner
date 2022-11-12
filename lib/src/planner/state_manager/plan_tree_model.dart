class PlanTreeModel {
  int id;
  String name;
  int? parentId;
  Map<String,double> gPosition;
  List childs;

  PlanTreeModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.gPosition,
    required this.childs,
  });

  PlanTreeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        parentId = json['parentId'],
        gPosition = json['gPosition'],
        childs = json['childs'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'parentId': parentId,
    'gPosition': gPosition,
    'childs': childs,
  };
}
