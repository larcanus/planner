import 'package:flutter/material.dart';

const Map<int, List<Color>> COLORS_GRADIENT = {
  4290091478: [
    Color(0xffb599d6),
    Color(0xffb599d6),
    Color(0xffc4ade6),
  ],
  4292001117: [
    Color(0xffd2bd92),
    Color(0xffddcaa0),
    Color(0xffd5c5a7),
    Color(0xffdad5bc),
  ],
  4290800506: [
    Color(0xffde7d8c),
    Color(0xffde9e9f),
    Color(0xffe5cdd3),
  ],
  4291034238: [
    Color(0xffc3fc7e),
    Color(0xffd0fd96),
    Color(0xffd8ffa8),
  ],
  4283608063: [
    Color(0xff52abff),
    Color(0xff7abfff),
    Color(0xffcce6ff),
  ],
  4294958336: [
    Color(0xffffdd00),
    Color(0xfffdde27),
    Color(0xffffef82),
  ],
  4281641282: [
    Color(0xff34a942),
    Color(0xff52cb54),
    Color(0xff7aef78),
  ],
  4294802564: [
    Color(0xfffd7c84),
    Color(0xfff1969b),
    Color(0xfff6d6c3),
  ],
  4281581311: [
    Color(0xff33beff),
    Color(0xff33beff),
    Color(0xff70d2ff),
  ],
  4291414473: [
    Color(0xffc9c9c9),
    Color(0xffd7d6d6),
    Color(0xffedefee),
  ],
};

const List<Color> COLORS_STEP_PALETTE = [
  Color(0xff33beff),
  Color(0xfffd7c84),
  Color(0xff45b252),
  Color(0xfffdde27),
  Color(0xffb599d6),
  Color(0xff6073be),
  Color(0xffb65c91),
  Color(0xff6b914a),
  Color(0xfff5c379),
  Color(0xff8576ee),
];
// locale RU:
/// settings locale
const String PATH_NAME_USER_PLANS_DATA = 'user_plans_data';
const String PATH_NAME_USER_SETNGS_DATA = 'user_settings_data';
const String SETTING_VERSION = 'Версия приложения';
const String SETTING_SCALE_BUTTONS = 'Включить кнопки маштабирования';
const String TITLE_CURRENT_PLAM_IS_NOT_ACTIVE = 'Активных нет';

/// current page
const String TITLE_CURRENT_PLAN = 'Текущий:';
const String DEFAULT_STEP_INFO_DESC = 'нет описания';
const String TITLE_BUTTON_ACTIVE = 'Переход';

/// plan lists page
const String SLIVER_APP_BAR_TITLE = 'Ваши планы:';
const String SLIVER_ADAPTER_TITLE = 'всего: ';
const String EDIT_STEP_TITLE_DLG = 'Редактировать';
const String DELETE_STEP_TITLE_DLG = 'Удалить';
const String ADD_EDIT_STEP_ADD_NEW_PLAN = 'Добавить новый план';
const String ADD_EDIT_STEP_NAME_DLG = 'Наименование';
const String ADD_EDIT_STEP_DESC_DLG = 'Краткое описание';
const String ADD_EDIT_STEP_VALID_DLG = 'Это поле не должно быть пустым';
const String ADD_EDIT_STEP_SAVE_DLG = 'Сохранить';
const String CONFIRM_CANCEL_DLG = 'Отмена';
const String CONFIRM_OK_DLG = 'Да';
const String CONFIRM_DELETE_TITLE = 'Предупреждение';
const String CONFIRM_DELETE_DESC = 'Вы действительно хотите удалить этот план?';

const String PLAN_LIST_ITEM_IS_ACTIVED = 'Активен';
const String PLAN_LIST_ITEM_SET_ACTIVE = 'Активировать';
const String PLAN_LIST_ITEM_BUILDING = 'Строить';


/// builder
const String ADD_STEP_TITLE_DLG = 'Добавить новый шаг';
const String NAME_ROOT_STEP = 'Шаг №1';
const String ALARM = 'Предупреждение';
const String CONFIRM_DELETE_STEP =
    'Вы действительно хотите удалить этот шаг? Будут удалены и все последующие шаги!';
const String STEP_TYPE_RECT = 'rect';
const String STEP_TYPE_CIRCLE = 'circle';
const double STEP_DECREASE_ACTIVE_COF = 1.3;
const double STEP_DECREASE_CHILD_COF = 2.6;
const double STEP_TEXT_BOX_FONT_SIZE = 18;
const double TEXT_BOX_FONT_SIZE_ACTIVE_STEP = 16 / STEP_DECREASE_ACTIVE_COF;
const double TEXT_BOX_FONT_SIZE_LAST_NEXT_STEP = 16 / STEP_DECREASE_CHILD_COF;
const double STROKE_BORDER_STEP_TOOLS = 6.0;


const Color COLOR_BUTTONS_STEP = Color(0xFF0C7391);
const Color COLOR_BUTTON_ACTIVATE = Color(0xFFE73030);
const Color DEFAULT_SCAFFOLD_BACKGROUND = Color(0xfffff7f7);
const Color DEFAULT_BACKGROUND_STEP = Color(0xFF728FAD);
const Color DEFAULT_BACKGROUND_BUILDER = Color(0xffD3D3D3);
const Color DEFAULT_BACKGROUND_BUILDER_FRONT_PAGE = Color(0xfffff7f7);
const Color COLOR_BORDER_EDIT_STEP_DLG = Color(0xff42a133);
const Color COLOR_LINE_BRANCH_STEPS = Color(0xff33beff);
const Color COLOR_BORDER_STEP_TOOLS = Color(0xFF020202);
const Color COLOR_NAME_STEP = Color(0xFF100E0E);
const Color COLOR_BORDER_ENABLED_DLG = Color(0xFFBBADAD);
const Color COLOR_BORDER_STEP_INFO = Color(0xFF565555);
const Color DEFAULT_COLOR_BACKGROUND_STEP_INFO = Color(0xFFC0C0C0);
