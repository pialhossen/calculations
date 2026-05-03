import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository repository;
  UpdateEmployeeUseCase(this.repository);
  Future<Employee> execute({ required int id, required String name, required String number, required double loanAmount, required String? image}) {
    return repository.updateEmployee(id ,name, number, loanAmount, image);
  }
}