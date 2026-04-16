import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/domain/entities/slip_entity.dart';
import 'package:calculations/features/slips/domain/entities/slip_item_entity.dart';

class SlipModel extends SlipEntity {
  SlipModel({
    super.id,
    required super.employee,
    required super.total,
    required super.slipItems,
    required super.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employee.id,
      'date_created': dateTime.toIso8601String(),
      'total_amount': total,
    };
  }

  factory SlipModel.fromMap(
    Map<String, dynamic> map,
    List<Map<String, dynamic>> itemMaps,
  ) {
    return SlipModel(
      id: map['id'],
      dateTime: DateTime.parse(map['date_created']),
      total: (map['total_amount'] as num).toDouble(),
      employee: Employee(
        id: map['employee_id'],
        name: map['employee_name'] ?? '',
        number: map['employee_number'] ?? '',
      ),
      // CONVERT MAPS TO OBJECTS HERE:
      slipItems: itemMaps.map((item) => SlipItemModel.fromMap(item)).toList(),
    );
  }
  SlipModel copyWith({
    int? id,
    Employee? employee,
    DateTime? dateTime,
    double? total,
    List<SlipItemEntity>? slipItems,
  }){
    return SlipModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      employee: employee ?? this.employee,
      total: total ?? this.total,
      slipItems: slipItems ?? this.slipItems,
    );
  }
}
