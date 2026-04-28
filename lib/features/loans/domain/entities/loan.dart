import 'package:calculations/features/employees/domain/entities/employee.dart';

class Loan {
  final int? id;
  final Employee employee;
  final double amount;
  final int type;
  final DateTime dateTime;
  String? note;

  Loan({
    this.id,
    this.note,
    required this.employee, 
    required this.amount, 
    required this.type, 
    required this.dateTime,
  });
}