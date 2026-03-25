import 'package:calculations/features/employees/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  EmployeeModel({
    super.id, 
    required super.name, 
    required super.number
  });
  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      number: map['number'],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      if(id != null) 'id': id,
      'name' : name,
      'number' : number,
    };
  }
}