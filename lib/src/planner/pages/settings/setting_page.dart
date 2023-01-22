

import 'package:flutter/cupertino.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(
      'Settings',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),);
  }
}
