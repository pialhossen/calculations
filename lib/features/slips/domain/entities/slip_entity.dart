import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/slips/domain/entities/step_entity.dart';

class SlipEntity {
  int? id;
  final Employee employee;
  final DateTime dateTime;
  double total;
  List<StepEntity> steps;

  SlipEntity({
    this.id,
    List<StepEntity>? steps,
    required this.employee,
    required this.dateTime,
    this.total = 0,
  }) : steps = steps ?? [];
}
