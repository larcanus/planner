class PlanTreeModel {
  int id;
  String name;
  int? parentId;
  Map<String,double> gPosition;
  List childs;
  double width;
  bool isCircle;
  double height;

  PlanTreeModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.gPosition,
    required this.width,
    required this.height,
    required this.isCircle,
    required this.childs,
  });

  PlanTreeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        parentId = json['parentId'],
        gPosition = json['gPosition'],
        width = json['width'],
        height = json['height'],
        isCircle = json['isCircle'],
        childs = json['childs'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'parentId': parentId,
    'gPosition': gPosition,
    'width': width,
    'height': height,
    'isCircle': isCircle,
    'childs': childs,
  };
}
