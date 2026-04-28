import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class UpdateLoanUseCase {
  final LoanRepository repository;
  UpdateLoanUseCase(this.repository);
  Future<LoanModel> execute({ required int id, required employeeId, required int type }) async {
    return await repository.updateLoan(id: id,employeeId: employeeId, type: type);
  }
}