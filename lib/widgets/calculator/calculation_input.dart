import 'package:flutter/material.dart';

class CalculationInput extends StatelessWidget {
  const CalculationInput({super.key});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   padding: EdgeInsets.all(10),
    //   alignment: Alignment.center,
    //   child: Text('2.7'),
    // );
    return SizedBox(
      width: 50,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: TextField(
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
