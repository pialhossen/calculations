// slip_entity.dart
import 'package:calculations/features/employees/domain/entities/employee.dart';
// 1. Change this import to the correct filename
import 'package:calculations/features/slips/domain/entities/slip_item_entity.dart'; 

class SlipEntity {
  final int? id;
  final Employee employee;
  final DateTime dateTime;
  final double total;
  // 2. Change StepEntity to SlipItemEntity
  final List<SlipItemEntity> steps; 

  SlipEntity({
    this.id,
    required this.employee,
    required this.dateTime,
    required this.total,
    required this.steps,
  });
}