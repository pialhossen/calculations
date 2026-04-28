import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class DeleteLoanUseCase {
  final LoanRepository repository;
  DeleteLoanUseCase(this.repository);
  Future<bool> execute(int id) async {
    return await repository.deleteLoan(id);
  }
}