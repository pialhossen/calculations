// slip_entity.dart
import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/slips/data/model/slip_item_model.dart';

class SlipEntity {
  final int? id;
  final String? note;
  final Employee employee;
  final DateTime dateTime;
  final double total;
  final List<SlipItemModel> slipItems; 

  SlipEntity({
    this.id,
    this.note,
    required this.employee,
    required this.dateTime,
    required this.total,
    required this.slipItems,
  });
}