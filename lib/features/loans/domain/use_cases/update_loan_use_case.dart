import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class UpdateLoanUseCase {
  final LoanRepository repository;
  UpdateLoanUseCase(this.repository);
  Future<LoanModel> execute({
    required int id,
    required int employeeId,
    required int type,
    required double amount,
    required String note,
  }) async {
    return await repository.updateLoan(
      id: id,
      employeeId: employeeId,
      type: type,
      amount: amount,
      note: note,
    );
  }
}
