import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);
  Future<Product> execute({required String name, required int perkg, required String? image}) {
    return repository.createNewProduct(name: name, perkg: perkg, image: image);
  }
}