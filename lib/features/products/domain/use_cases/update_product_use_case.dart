import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);
  Future<Product> execute({ required int id, required String name, required int perkg, String? image }) {
    return repository.updateProduct(id: id, name: name, perkg: perkg,  image: image);
  }
}