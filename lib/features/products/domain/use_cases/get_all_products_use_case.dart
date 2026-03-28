import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;
  GetAllProductsUseCase({required this.repository});
  Future<List<Product>> execute() async {
    return await repository.getProducts();
  }
}