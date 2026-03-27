import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository repository;
  DeleteEmployeeUseCase(this.repository);
  Future<void> execute(int id) {
    return repository.deleteEmployee(id);
  }
}