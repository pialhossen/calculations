import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) onChange;
  final String? initialValue; // Pass the starting ID here

  const Select({
    super.key,
    required this.products,
    required this.onChange,
    this.initialValue,
  });

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? _internalValue;

  @override
  void initState() {
    super.initState();
    // Set the initial selection once when the widget is born
    _internalValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const Text("...");

    // 1. Safety check: make sure the value actually exists in the list
    bool exists = widget.products.any((p) => p.id.toString() == _internalValue);
    if (!exists) {
      _internalValue = widget.products.first.id.toString();
    }

    return Container(
      width: 70,
      height: 30,
      child: DropdownButton<String>(
        value: _internalValue, // 2. Use the INTERNAL state variable
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.products.map((Product product) {
          return DropdownMenuItem<String>(
            value: product.id.toString(),
            child: Text(product.name),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue == null) return;
          setState(() {
            _internalValue = newValue;
          });
          final selectedProduct = widget.products.firstWhere(
            (p) => p.id.toString() == newValue,
          );
          widget.onChange(selectedProduct); 
        },
      ),
    );
  }
}