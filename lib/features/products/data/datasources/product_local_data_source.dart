import 'package:calculations/features/products/data/model/product_model.dart';

abstract interface class ProductLocalDataSource {
  Future<int> createProduct(ProductModel product);
  Future<int> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<List<ProductModel>> getProducts();
}