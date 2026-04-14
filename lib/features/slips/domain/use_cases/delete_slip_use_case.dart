import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class DeleteSlipUseCase {
  final SlipRepository repository;
  DeleteSlipUseCase(this.repository);
  Future<void> execute(int id) {
    return repository.deleteSlip(id);
  }
}