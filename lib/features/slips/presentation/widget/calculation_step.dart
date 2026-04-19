import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/slips/domain/entities/slip_item_entity.dart';
import 'package:calculations/features/slips/presentation/widget/calculation_input.dart';
import 'package:calculations/core/widgets/product_select.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculationStep extends StatefulWidget {
  final VoidCallback delete;
  double rowTotal;
  final Function({required double total, required double perKg, required double kg}) onCalculationChanged;
  final Function(Product) onProductChange;
  final List<Product> products;
  final SlipItemEntity? slipItem; 
  CalculationStep({
    super.key,
    this.rowTotal = 0.0,
    required this.products,
    required this.delete,
    required this.onCalculationChanged,
    required this.onProductChange,
    this.slipItem
  });

  @override
  State<CalculationStep> createState() => _CalculationStepState();
}

class _CalculationStepState extends State<CalculationStep> {
  String? initialValue;
  TextEditingController perKgController = TextEditingController(); 
  TextEditingController kgController = TextEditingController();
  String _totalPrice = "0.00";

  void handleProductChange(Product? newProduct) {
    if (newProduct == null) return;
    setState(() {
      perKgController.text = newProduct.perkg.toString();
    });
    widget.onProductChange(newProduct);
  }
  void _calculatePrice() {
    final double perKg = double.tryParse(perKgController.text) ?? 0;
    final double kg = double.tryParse(kgController.text) ?? 0;

    setState(() {
      final total = perKg * kg;
      _totalPrice = total.floor().toString();
      widget.onCalculationChanged(kg: kg, perKg: perKg, total: total);
    });
  }

  @override
  void initState() { 
    super.initState();
    initialValue = widget.slipItem != null? widget.slipItem!.product.id.toString(): widget.products.first.id.toString();
    perKgController.text = widget.slipItem!.perKg != 0? widget.slipItem!.perKg.toString() : widget.products.first.perkg.toString();
    perKgController.text = widget.products.first.perkg.toString();
    kgController.text = widget.slipItem != null? widget.slipItem!.kg.toString() : '0';
    perKgController.addListener(_calculatePrice);
    kgController.addListener(_calculatePrice);
    _totalPrice= widget.slipItem != null? widget.slipItem!.rowTotal.floor().toString() : '0';
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
              // padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.arrow_forward, size: 16),
            ),
            CalculationInput(controller: perKgController),
            Container(
              // padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(Icons.close),
            ),
            CalculationInput(controller: kgController,),
            Container(
              // padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.equals, size: 16),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(_totalPrice),
            ),
            GestureDetector(
              onTap: widget.delete,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
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
