import 'package:flutter/material.dart';

class CalculationInput extends StatelessWidget {
  final TextEditingController controller;
  const CalculationInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
          ),
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            // This removes the default underline/border
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // Optional: adjust padding to center text vertically
            contentPadding: EdgeInsets.only(bottom: 5),
          ),
        ),
      ),
    );
  }
}
