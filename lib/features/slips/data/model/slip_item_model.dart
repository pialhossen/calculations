import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/slips/domain/entities/slip_item_entity.dart';

class SlipItemModel extends SlipItemEntity {
  // Use the super constructor to pass data to the Entity
  SlipItemModel({
    super.id,
    required super.product,
    required super.kg,
    required super.perKg,
    required super.rowTotal,
  });

  // Convert Model to Map for Database insertion
  Map<String, dynamic> toMap(int slipId) {
    return {
      'slip_id': slipId, 
      'product_id': product!.id,
      'kg': kg,
      'per_kg': perKg,
      'row_total': rowTotal,
    };
  }

  // Factory to create Model from Database Map
  factory SlipItemModel.fromMap(Map<String, dynamic> map) {
    return SlipItemModel(
      id: map['id'],
      product: Product(
        id: map['product_id'],
        name: map['product_name'],
        perkg: map['product_perkg'],
      ),
      kg: (map['kg'] as num).toDouble(),
      perKg: (map['per_kg'] as num).toDouble(),
      rowTotal: (map['row_total'] as num).toDouble(),
    );
  }
}