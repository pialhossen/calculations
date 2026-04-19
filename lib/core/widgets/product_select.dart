import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductSelect extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) onChange;
  final String? initialValue;

  const ProductSelect({
    super.key,
    required this.products,
    required this.onChange,
    this.initialValue,
  });

  @override
  State<ProductSelect> createState() => _ProductSelectState();
}

class _ProductSelectState extends State<ProductSelect> {
  String? _internalValue;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue == null){
      _internalValue = widget.products.first.id.toString();
    } else {
      _internalValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const Text("...");

    return Container(
      width: 60,
      height: 30,
      child: DropdownButton<String>(
        value: _internalValue, // 2. Use the INTERNAL state variable
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.products.map((Product product) {
          return DropdownMenuItem<String>(
            value: product.id.toString(),
            child: Text(product.name, style: TextStyle(fontSize: 13),),
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