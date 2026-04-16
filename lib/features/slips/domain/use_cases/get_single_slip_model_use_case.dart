import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class GetSingleSlipModelUseCase {
  final SlipRepository repository;
  GetSingleSlipModelUseCase(this.repository);
  Future<SlipModel> execute(int id) async {
    return repository.getSlip(id);
  }
}