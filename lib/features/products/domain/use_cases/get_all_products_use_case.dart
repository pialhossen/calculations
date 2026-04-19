import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;
  GetAllProductsUseCase(this.repository);
  Future<List<Product>> execute(String? q) async {
    return await repository.getProducts(q);
  }
}