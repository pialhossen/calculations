import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class UpdateSlipUseCase {
  final SlipRepository repository;
  UpdateSlipUseCase(this.repository);
  Future<Product> execute() {
    return repository.updateProduct();
  }
}