import 'package:calculations/features/slips/domain/entities/slip_item_entity.dart';

class SlipItemModel extends SlipItemEntity {
  // Use the super constructor to pass data to the Entity
  SlipItemModel({
    super.id,
    required super.productName,
    required super.kg,
    required super.perKg,
    required super.rowTotal,
  });

  // Convert Model to Map for Database insertion
  Map<String, dynamic> toMap(int slipId) {
    return {
      'slip_id': slipId, 
      'product_name': productName,
      'kg': kg,
      'per_kg': perKg,
      'row_total': rowTotal,
    };
  }

  // Factory to create Model from Database Map
  factory SlipItemModel.fromMap(Map<String, dynamic> map) {
    return SlipItemModel(
      id: map['id'],
      productName: map['product_name'] ?? '',
      kg: (map['kg'] as num).toDouble(),
      perKg: (map['per_kg'] as num).toDouble(),
      rowTotal: (map['row_total'] as num).toDouble(),
    );
  }
}