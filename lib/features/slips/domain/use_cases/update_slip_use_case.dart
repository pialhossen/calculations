import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class UpdateSlipUseCase {
  final SlipRepository repository;
  UpdateSlipUseCase(this.repository);
  Future<SlipModel> execute({
    String? note, 
    required int id, 
    required int employeeId, 
    required double totalAmount, 
    required List<SlipItemModel> slipItems
  }) {
    return repository.updateSlip(
      id, 
      employeeId: employeeId, 
      note: note, 
      totalAmount: totalAmount, 
      slipItems: slipItems
    );
  }
}