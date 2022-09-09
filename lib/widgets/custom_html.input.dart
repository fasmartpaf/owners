import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomHtmlInput extends StatefulWidget {
  const CustomHtmlInput({this.quilController, Key key}) : super(key: key);

  final QuillController quilController;

  @override
  State<CustomHtmlInput> createState() => _CustomHtmlInputState();
}

class _CustomHtmlInputState extends State<CustomHtmlInput> {
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        QuillToolbar.basic(controller: widget.quilController),
        UiSpacer.divider(),
        Container(
          height: context.percentHeight * 30,
          child: QuillEditor.basic(
            controller: widget.quilController,
            readOnly: false,
          ),
        ).px12().py8(),
      ],
    ).p2().box.border(color: Colors.grey.shade300).roundedSM.make();
  }
}
