class StepModel {
  int id;
  String name;
  String description;
  String background;
  int parentId;
  Map gPosition;
  List childs;
  double width;
  String type;
  double height;

  StepModel({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.parentId,
    required this.gPosition,
    required this.width,
    required this.height,
    required this.type,
    required this.childs,
  });

  StepModel.clone(StepModel originalModel)
      : id = originalModel.id,
        name = originalModel.name,
        description = originalModel.description,
        background = originalModel.background,
        parentId = originalModel.parentId,
        gPosition = Map.from( originalModel.gPosition ),
        width = originalModel.width,
        height = originalModel.height,
        type = originalModel.type,
        childs = List<StepModel>.from(originalModel.childs);

  StepModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        background = json['background'],
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
        'background': background,
        'parentId': parentId,
        'gPosition': gPosition,
        'width': width,
        'height': height,
        'type': type,
        'childs': childs,
      };
}
