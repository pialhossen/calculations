import 'package:calculations/features/products/data/datasources/product_local_data_source.dart';
import 'package:calculations/features/products/data/datasources/product_local_data_source_impl.dart';
import 'package:calculations/features/products/data/model/product_model.dart';
import 'package:calculations/features/products/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource productLocalDataSource = ProductLocalDataSourceImpl();
  @override
  Future<ProductModel> createNewProduct(String name, int perkg) async {
    final newProducts = ProductModel(name: name, perkg: perkg);
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
  Future<List<ProductModel>> getProducts() async {
    return await productLocalDataSource.getProducts();
  }

  @override
  Future<ProductModel> updateProduct(int id, String name, int perkg) async {
    final updatedProduct = ProductModel(id: id,name: name, perkg: perkg);
    productLocalDataSource.updateProduct(updatedProduct);
    return updatedProduct;
  }

}