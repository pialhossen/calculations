import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class GetAllLoanOfEmployeeUseCase {
  final LoanRepository repository;
  GetAllLoanOfEmployeeUseCase(this.repository);
  Future<List<LoanModel>> execute(int employeeId) async {
    return await repository.getLoans(employeeId);
  }
}