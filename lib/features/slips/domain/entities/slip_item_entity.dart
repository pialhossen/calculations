import 'package:calculations/features/products/domain/entities/product.dart';

class SlipItemEntity {
  final int? id;
  Product product;
  double kg;
  double perKg;
  double rowTotal; // Remove 'final' here

  SlipItemEntity({
    this.id,
    required this.product,
    this.kg = 0.0,
    this.perKg = 0.0,
    this.rowTotal = 0.0,
  });
}