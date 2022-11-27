class PlanTreeModel {
  int id;
  String name;
  String description;
  int parentId;
  Map gPosition;
  List childs;
  double width;
  String type;
  double height;

  PlanTreeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.parentId,
    required this.gPosition,
    required this.width,
    required this.height,
    required this.type,
    required this.childs,
  });

  PlanTreeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        parentId = json['parentId'],
        gPosition = json['gPosition'],
        width = json['width'],
        height = json['height'],
        type = json['type'],
        childs = json['childs'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'parentId': parentId,
        'gPosition': gPosition,
        'width': width,
        'height': height,
        'type': type,
        'childs': childs,
      };
}
