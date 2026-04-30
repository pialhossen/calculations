import 'package:calculations/features/employees/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  EmployeeModel({
    super.id, 
    required super.name, 
    required super.number,
    required super.loanAmount
  });
  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      loanAmount: map['loan_amount'],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      if(id != null) 'id': id,
      'name' : name,
      'number' : number,
      'loan_amount' : loanAmount
    };
  }
  EmployeeModel copyWith({
    int? id,
    String? name,
    String? number,
    double? loanAmount,
  }){
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name, 
      number: number ?? this.number,
      loanAmount: loanAmount ?? this.loanAmount,
    );
  }
}