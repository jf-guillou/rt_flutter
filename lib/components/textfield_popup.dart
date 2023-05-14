import 'package:flutter/material.dart';

class TextFieldPopup extends StatefulWidget {
  final String header;
  final String hint;
  final String defaultValue;
  final Function onchange;
  const TextFieldPopup(this.header, this.hint, this.defaultValue, this.onchange,
      {Key? key})
      : super(key: key);

  @override
  State<TextFieldPopup> createState() => TextFieldPopupState();
}

class TextFieldPopupState extends State<TextFieldPopup> {
  String? textFieldValue;
  @override
  void initState() {
    textFieldValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.header),
      content: TextFormField(
        initialValue: widget.defaultValue,
        onChanged: (value) {
          textFieldValue = value;
        },
        decoration: InputDecoration(hintText: widget.hint),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onchange(textFieldValue);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
