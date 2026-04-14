import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';
import 'package:calculations/features/slips/domain/entities/slip_entity.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class  CreateSlipUseCase {
  final SlipRepository repository;
  CreateSlipUseCase(this.repository);
  Future<SlipEntity> execute() {
    return repository.createNewSlip();
  }
}