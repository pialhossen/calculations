import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class GetAllSlipUseCase {
  final SlipRepository repository;
  GetAllSlipUseCase(this.repository);
  Future<List<Product>> execute() async {
    return await repository.getSlips();
  }
}