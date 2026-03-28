import 'package:calculations/features/products/domain/repository/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;
  DeleteProductUseCase({required this.repository});
  Future<void> execute(int id) {
    return repository.deleteProduct(id);
  }
}