import 'package:calculations/features/products/data/model/product_model.dart';

abstract interface class ProductRepository {
  Future<ProductModel> createNewProduct(String name, int perkg);
  Future<ProductModel> updateProduct(int id,String name, int perkg);
  Future<bool> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<List<ProductModel>> getProducts(String? q);
}