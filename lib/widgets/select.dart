import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  const Select({super.key});

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  // 1. Create a variable to hold the current selection
  String selectedValue = "Apple"; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 70, // Increased slightly so text doesn't feel cramped
        height: 30,
        child: DropdownButton<String>(
          // 2. Use the variable here instead of a hardcoded string
          value: selectedValue, 
          isExpanded: true,
          underline: const SizedBox(),
          items: <String>['Apple', 'Banana', 'Cherry'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            // 3. Update the variable inside setState
            setState(() {
              if (newValue != null) {
                selectedValue = newValue;
              }
            });
          },
        ),
      ),
    );
  }
}