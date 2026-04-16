import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class GetAllSlipUseCase {
  final SlipRepository repository;
  GetAllSlipUseCase(this.repository);
  Future<List<SlipModel>> execute() async {
    return await repository.getSlips();
  }
}