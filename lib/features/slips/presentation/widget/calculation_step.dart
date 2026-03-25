import 'package:calculations/features/slips/presentation/widget/calculation_input.dart';
import 'package:calculations/core/widgets/select.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculationStep extends StatelessWidget {
  final VoidCallback delete;
  const CalculationStep({
    super.key,
    required this.delete
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Select(),
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.arrow_forward, size: 20),
            ),
            CalculationInput(),
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.close),
            ),
            CalculationInput(),
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.equals, size: 18),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text('20345.7'),
            ),
            GestureDetector(
              onTap: delete,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
