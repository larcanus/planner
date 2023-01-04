import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/utils.dart';

import '../../constants.dart';
import '../../state_manager/plan_controller.dart';
import 'builder_page.dart';

class StepEditDlg extends StatefulWidget {
  final String title;
  final String background;
  final String? description, name;
  final int? stepId;
  final MyGame game;

  const StepEditDlg(
      {required Key key,
      required this.game,
      required this.title,
      this.name,
      this.description,
      this.background = '#ff33beff',
      this.stepId})
      : super(key: key);

  @override
  State<StepEditDlg> createState() => _StepEditDlgState();
}

class _StepEditDlgState extends State<StepEditDlg> {
  final _formKey = GlobalKey<FormState>();
  final PlanController planController = Get.find();
  final TextEditingController _textFormTitleController =
      TextEditingController();
  final TextEditingController _textFormDescController = TextEditingController();


  late final String title;
  late Color currentColor;
  late final String? name, description;
  late final int? stepId;

  @override
  initState() {
    title = widget.title;
    name = widget.name;
    currentColor = HexColor.fromHex(widget.background);
    description = widget.description;
    stepId = widget.stepId;
    _textFormTitleController.text = name ?? '';
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
      for (var item in COLORS_STEP_PALETTE) {
        colors.add(item);
      }
      return colors;
    }

    return Container(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
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
              Text(
                title,
                style: const TextStyle(fontSize: 23),
              ),
              sizedBoxSpace,
              TextFormField(
                restorationId: 'title_field',
                textInputAction: TextInputAction.next,
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: COLOR_BORDER_EDIT_STEP_DLG)),
                  labelText: ADD_EDIT_STEP_NAME_DLG,
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
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: COLOR_BORDER_EDIT_STEP_DLG)),
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
                    if (stepId == null) {
                      widget.game.overlays.remove('addStepOverlay');
                      planController.addStep(_textFormTitleController.text,
                          _textFormDescController.text, currentColor.toHex());
                    } else {
                      widget.game.overlays.remove('editStepOverlay');
                      planController.updateStepById(
                          stepId,
                          _textFormTitleController.text,
                          _textFormDescController.text,
                          currentColor.toHex());
                    }
                    widget.game.overlays.add('buttonRevert');
                    widget.game.refreshTree();
                    planController.selectStepById();
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
