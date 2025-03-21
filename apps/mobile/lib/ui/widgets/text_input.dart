import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    this.placeholder,
    this.label,
    this.controller,
    this.type = TextInputType.text,
  });
  final TextInputType type;
  final String? placeholder;
  final String? label;
  final TextEditingController? controller;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    final label = widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label, style: TextStyle(color: Colors.black, fontSize: 18.0)),
        const Gap(3.0),
        TextFormField(
          keyboardType: widget.type,
          controller: widget.controller,
          cursorColor: Colors.black,
          cursorWidth: 1.5,
          cursorHeight: 18.0,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            hintText: widget.placeholder,
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
      ],
    );
  }
}
