import 'package:calculations/core/database/database_helper.dart';
import 'package:calculations/features/products/data/datasources/product_local_data_source.dart';
import 'package:calculations/features/products/data/model/product_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<int> createProduct(ProductModel product) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(
      'product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> deleteProduct(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.delete('product', where: 'id = ?', whereArgs: [id]);
    return result > 0;
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return ProductModel.fromMap(maps.first);
    } else {
      throw Exception("Product with ID $id not found!");
    }
  }

  @override
  Future<List<ProductModel>> getProducts(String? q) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> maps;

    if (q != null && q.trim().isNotEmpty) {
      // Searches for products where the name contains the string Q
      maps = await db.query(
        'product',
        where: 'name LIKE ?',
        whereArgs: ['%$q%'],
        orderBy: 'id DESC',
      );
    } else {
      // Returns all products if no query is provided
      maps = await db.query('product', orderBy: 'id DESC');
    }

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  @override
  Future<int> updateProduct(ProductModel product) async {
    if (product.id == null) {
      throw Exception("Cannot update an product without an ID.");
    }
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}
