import 'package:flutter/material.dart';
class StyledDropdown extends StatefulWidget {
  @override
  State<StyledDropdown> createState() => _StyledDropdownState();
}

class _StyledDropdownState extends State<StyledDropdown> {
  String selectedValue = "Small";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: Icon(Icons.arrow_drop_down),
          items: [
            DropdownMenuItem(value: "Small", child: Text("Small")),
            DropdownMenuItem(value: "Medium", child: Text("Medium")),
            DropdownMenuItem(value: "Large", child: Text("Large")),
          ],
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
          },
        ),
      ),
    );
  }
}
