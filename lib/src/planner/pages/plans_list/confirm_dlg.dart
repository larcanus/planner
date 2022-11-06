import 'package:flutter/material.dart';

class ConfirmDlg extends StatefulWidget {
  final String title, description;
  final Function? callback;

  const ConfirmDlg(
      {Key? key, required this.title, required this.description, this.callback})
      : super(key: key);

  @override
  State<ConfirmDlg> createState() => _ConfirmDlgState();
}

class _ConfirmDlgState extends State<ConfirmDlg> {
  @override
  Widget build(BuildContext context) {
    final String title = widget.title;
    final String description = widget.description;
    final Function? callback = widget.callback;

    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (callback != null) {
              callback();
            }
            Navigator.pop(context, true);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
