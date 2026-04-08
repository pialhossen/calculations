import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/slips/presentation/widget/calculation_input.dart';
import 'package:calculations/core/widgets/product_select.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculationStep extends StatefulWidget {
  final VoidCallback delete;
  final List<Product> products;
  const CalculationStep({
    super.key,
    required this.products,
    required this.delete
  });

  @override
  State<CalculationStep> createState() => _CalculationStepState();
}

class _CalculationStepState extends State<CalculationStep> {
  String? initialValue;
  Product? _selectedProduct; 
  TextEditingController perKgController = TextEditingController(); 
  TextEditingController kgController = TextEditingController();

  void handleProductChange(Product? newProduct) {
    if (newProduct == null) return;
    setState(() {
      _selectedProduct = newProduct;
      perKgController.text = newProduct.perkg.toString();
    });
  }

  @override
  void initState() { 
    super.initState();
    initialValue = widget.products.first.name;
    perKgController.text = widget.products.first.perkg.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductSelect(products: widget.products, onChange: handleProductChange, initialValue: initialValue,),
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.arrow_forward, size: 20),
            ),
            CalculationInput(controller: perKgController),
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.close),
            ),
            CalculationInput(controller: kgController,),
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
              onTap: widget.delete,
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
