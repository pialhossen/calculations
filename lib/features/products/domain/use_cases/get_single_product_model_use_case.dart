import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class GetSingleProductModelUseCase {
  final ProductRepository repository;
  GetSingleProductModelUseCase(this.repository);
  Future<Product> execute(int id) async {
    return repository.getProduct(id);
  }
}