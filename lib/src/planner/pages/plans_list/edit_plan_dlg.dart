import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../constants.dart';

class EditPlanDialog extends StatefulWidget {
  final String? title, description;
  final int? id;

  const EditPlanDialog(
      {required Key key, this.title, this.description, this.id})
      : super(key: key);

  @override
  State<EditPlanDialog> createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final PlanController contItemList = Get.find();
  final TextEditingController _textFormTitleController =
      TextEditingController();
  final TextEditingController _textFormDescController = TextEditingController();
  Color currentColor = const Color(0xffb599d6);

  late final String? title;
  late final String? description;
  late final int? id;

  @override
  initState() {
    title = widget.title;
    description = widget.description;
    id = widget.id;

    _textFormTitleController.text = title ?? '';
    _textFormDescController.text = description ?? '';
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    const sizedBoxSpace = SizedBox(height: 14);

    List<Color> getColorConstant() {
      List<Color> colors = [];
      for (var item in COLORS_GRADIENT.entries) {
        colors.add(Color(item.key));
      }
      return colors;
    }

    return Container(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: DEFAULT_SCAFFOLD_BACKGROUND,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                ADD_EDIT_STEP_ADD_NEW_PLAN,
                style: TextStyle(fontSize: 23),
              ),
              sizedBoxSpace,
              TextFormField(
                restorationId: 'title_field',
                textInputAction: TextInputAction.next,
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  labelText: ADD_EDIT_STEP_NAME_DLG,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: COLOR_BORDER_ENABLED_DLG)),
                ),
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ADD_EDIT_STEP_VALID_DLG;
                  }
                  return null;
                },
                controller: _textFormTitleController,
              ),
              sizedBoxSpace,
              TextFormField(
                restorationId: 'desc_field',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                maxLength: 100,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: COLOR_BORDER_ENABLED_DLG)),
                  labelText: ADD_EDIT_STEP_DESC_DLG,
                ),
                controller: _textFormDescController,
              ),
              BlockPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
                availableColors: getColorConstant(),
                layoutBuilder: pickerLayoutBuilder,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (id == null) {
                      contItemList.addItemList(_textFormTitleController.text,
                          _textFormDescController.text, currentColor.value);
                    } else {
                      contItemList.updateItemListById(
                          id,
                          _textFormTitleController.text,
                          _textFormDescController.text,
                          currentColor.value);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: const Text(ADD_EDIT_STEP_SAVE_DLG),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget pickerLayoutBuilder(
    BuildContext context, List<Color> colors, PickerItem child) {
  return SizedBox(
    width: 300,
    height: 130,
    child: GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}
