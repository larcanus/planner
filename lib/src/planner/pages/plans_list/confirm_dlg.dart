import 'package:flutter/material.dart';

class ConfirmDlg extends StatefulWidget {
  final String title, description;
  final Function? callbackCancel;
  final Function? callbackOk;

  const ConfirmDlg(
      {Key? key,
      required this.title,
      required this.description,
      this.callbackOk,
      this.callbackCancel})
      : super(key: key);

  @override
  State<ConfirmDlg> createState() => _ConfirmDlgState();
}

class _ConfirmDlgState extends State<ConfirmDlg> {
  @override
  Widget build(BuildContext context) {
    final String title = widget.title;
    final String description = widget.description;
    final Function? callbackOk = widget.callbackOk;
    final Function? callbackCancel = widget.callbackCancel;

    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (callbackCancel != null) {
              callbackCancel();
            } else {
              Navigator.pop(context, true);
            }
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (callbackOk != null) {
              callbackOk();
            } else {
              Navigator.pop(context, true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
