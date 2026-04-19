import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool hidden;
  final TextInputType keyboardType;
  const Input({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.hidden = false,
    this.keyboardType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        TextFormField(
          obscureText: hidden,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "$placeholder is missing";
            }
            if (value.length > 12) {
              return "$placeholder is too big";
            }
            return null;
          },
        ),
      ],
    );
  }
}
