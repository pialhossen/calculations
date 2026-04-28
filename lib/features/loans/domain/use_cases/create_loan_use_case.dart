import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class CreateLoanUseCase {
  final LoanRepository repository;
  CreateLoanUseCase(this.repository);
  Future<LoanModel> execute({
    required int employeeId,
    required double amount,
    required int type,
    String? note,
  }) {
    return repository.createNewLoan(
      employeeId: employeeId,
      amount: amount,
      type: type,
      note: note,
    );
  }
}
