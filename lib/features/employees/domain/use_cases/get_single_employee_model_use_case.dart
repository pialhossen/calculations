import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class GetSingleEmployeeModelUseCase {
  final EmployeeRepository repository;
  GetSingleEmployeeModelUseCase(this.repository);
  Future<EmployeeModel> execute(int id) async {
    return repository.getEmployee(id);
  }
}