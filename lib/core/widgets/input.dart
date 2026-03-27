import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool hidden;
  const Input({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.hidden = false,
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
          decoration: InputDecoration(
            hintText: placeholder,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red.shade400
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6)
            ),
            filled: true,
            fillColor: Colors.white
          ),
          validator: (value) {
            if(value!.isEmpty){
              return "$placeholder is missing";
            }
            return null;
          },
        ),
      ],
    );
  }
}
