class PlanTreeModel {
  int id;
  String name;
  int? parentId;
  List childIds;

  PlanTreeModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.childIds,
  });

  PlanTreeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        parentId = json['parentId'],
        childIds = json['childIds'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'parentId': parentId,
    'childIds': childIds,
  };
}
