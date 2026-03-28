import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);
  Future<Product> execute(String name, int perkg) {
    return repository.createNewProduct(name, perkg);
  }
}