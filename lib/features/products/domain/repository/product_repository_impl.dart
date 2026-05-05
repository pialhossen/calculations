import 'package:calculations/features/products/data/datasources/product_local_data_source.dart';
import 'package:calculations/features/products/data/datasources/product_local_data_source_impl.dart';
import 'package:calculations/features/products/data/model/product_model.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource productLocalDataSource = ProductLocalDataSourceImpl();
  @override
  Future<ProductModel> createNewProduct({required String name, required int perkg, required String? image}) async {
    final newProducts = ProductModel(name: name, perkg: perkg, image: image);
    final id = await productLocalDataSource.createProduct(newProducts);
    return newProducts.copyWith(id: id);
  }

  @override
  Future<bool> deleteProduct(int id) {
    return productLocalDataSource.deleteProduct(id);
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    return await productLocalDataSource.getProduct(id);
  }

  @override
  Future<List<ProductModel>> getProducts(String? q) async {
    return await productLocalDataSource.getProducts(q);
  }

  @override
  Future<ProductModel> updateProduct({required int id, required String name, required int perkg, required String? image}) async {
    final updatedProduct = ProductModel(id: id,name: name, perkg: perkg, image: image);
    productLocalDataSource.updateProduct(updatedProduct);
    return updatedProduct;
  }

}