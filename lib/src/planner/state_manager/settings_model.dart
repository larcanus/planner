class Settings {
  bool isShowButtonsScale = true;

  Settings({Map? setting}) {
    if( setting != null ){
      isShowButtonsScale = setting['isShowButtonsScale'];
    }
  }

  Settings.clone(Settings originalSettings)
      : isShowButtonsScale = originalSettings.isShowButtonsScale;

  Settings.fromJson(Map<String, dynamic> json)
      : isShowButtonsScale = json['isShowButtonsScale'];

  Map<String, dynamic> toJson() => {
        'isShowButtonsScale': isShowButtonsScale,
      };

  Map<String, dynamic> toMap() {
    return {
      'isShowButtonsScale': isShowButtonsScale,
    };
  }
}
