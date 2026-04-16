import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/domain/entities/slip_entity.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class  CreateSlipUseCase {
  final SlipRepository repository;
  CreateSlipUseCase(this.repository);
  Future<SlipEntity> execute({
    required int employeeId, 
    required double totalAmount, 
    required List<SlipItemModel> slipItems, 
    required String? note
  }) {
    return repository.createNewSlip(
      employeeId: employeeId, 
      note: note, 
      slipItems: slipItems, 
      totalAmount: totalAmount
    );
  }
}