import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);
  Future<Product> execute(int id, String name, int perkg) {
    return repository.updateProduct(id ,name, perkg);
  }
}