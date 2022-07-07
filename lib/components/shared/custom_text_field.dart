import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Widget title;
  final TextEditingController? controller;
  final TextInputAction? action;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;

  const CustomTextField({
    Key? key,
    this.action,
    this.type,
    this.validator,
    this.controller,
    required this.title,
    this.inputFormatters,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        title,
        Flexible(
          child: TextFormField(
            autofocus: autoFocus,
            controller: controller,
            textInputAction: action,
            keyboardType: type,
            inputFormatters: inputFormatters,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 4, bottom: 4),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
