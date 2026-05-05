import 'package:calculations/features/products/data/model/product_model.dart';

abstract interface class ProductRepository {
  Future<ProductModel> createNewProduct({required String name, required int perkg, required String? image});
  Future<ProductModel> updateProduct({required int id, required String name, required int perkg, required String? image});
  Future<bool> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<List<ProductModel>> getProducts(String? q);
}