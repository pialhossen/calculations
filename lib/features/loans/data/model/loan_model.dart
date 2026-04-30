import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/domain/entities/loan.dart';

class LoanModel extends Loan {
  LoanModel({
    super.id,
    super.note,
    required super.employee,
    required super.amount,
    required super.type,
    required super.dateTime,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'employee_id': employee.id,
      'amount': amount,
      'type': type,
      'date_created': dateTime.toIso8601String(),
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'],
      dateTime: DateTime.parse(map['date_created']),
      amount: map['amount'],
      type: map['type'],

      employee: Employee(
        id: map['employee_id'] ?? 1,
        name: map['employee_name'] ?? '',
        number: map['employee_number'] ?? '',
        loanAmount: map['loan_amount'] ?? 0,
      ),
      note: map['note'],
    );
  }
  LoanModel copyWith({
    int? id,
    Employee? employee,
    DateTime? dateTime,
    double? amount,
    int? type,
    String? note,
  }) {
    return LoanModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      employee: employee ?? this.employee,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }
}
