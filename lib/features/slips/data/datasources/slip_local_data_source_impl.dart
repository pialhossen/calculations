import 'package:calculations/core/database/database_helper.dart'; // Adjust path
import 'package:calculations/features/slips/data/datasources/slip_local_data_source.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';

class SlipLocalDataSourceImpl implements SlipLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Future<int> createSlip(SlipModel slip) async {
    final db = await dbHelper.database;

    print(slip.toMap());

    return await db.transaction((txn) async {
      int slipId = await txn.insert('slips', slip.toMap());
      for (var slipItem in slip.slipItems) {
        await txn.insert('slip_items', slipItem.toMap(slipId));
      }
      return slipId;
    });
  }

  @override
  Future<List<SlipModel>> getSlips() async {
    final db = await dbHelper.database;

    // Join with employee to get the name for the Employee entity
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT slips.*, employee.name as employee_name, employee.number as employee_number
      FROM slips
      LEFT JOIN employee ON slips.employee_id = employee.id
      ORDER BY slips.id DESC
    ''');

    List<SlipModel> slips = [];

    for (var map in maps) {
      // For each slip, fetch its specific items
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'slip_items',
        where: 'slip_id = ?',
        whereArgs: [map['id']],
      );

      // For each slip item, fetch the product details
      List<Map<String, dynamic>> itemMapsWithProduct = [];
      for (var item in itemMaps) {
        final List<Map<String, dynamic>> productMaps = await db.query(
          'product',
          where: 'id = ?',
          whereArgs: [item['product_id']],
        );
        if (productMaps.isNotEmpty) {
          final product = productMaps.first;
          itemMapsWithProduct.add({
            ...item,
            'product_id': product['id'],
            'product_name': product['name'],
            'product_perkg': product['perkg'],
          });
        } else {
          itemMapsWithProduct.add(item);
        }
      }
      slips.add(SlipModel.fromMap(map, itemMapsWithProduct));
    }

    return slips;
  }

  @override
  Future<SlipModel> getSlip(int id) async {
    final db = await dbHelper.database;
    

    final List<Map<String, dynamic>> maps = await db.query(
      'slips',
      where: 'id = ?',
      whereArgs: [id],
    );


    if (maps.isNotEmpty) {
      
      final List<Map<String, dynamic>> itemMaps = await db.rawQuery('''
        SELECT 
          si.*, 
          p.name as product_name, 
          p.perkg as product_perkg
        FROM slip_items si
        INNER JOIN product p ON si.product_id = p.id
        WHERE si.slip_id = ?
      ''', [id]);
      // Assuming you have an Employee lookup logic here
      SlipModel slipModel = SlipModel.fromMap(maps.first, itemMaps);
      return slipModel;
    } else {
      throw Exception("Slip not found");
    }
  }

  @override
  Future<bool> deleteSlip(int id) async {
    final db = await dbHelper.database;
    // Because of ON DELETE CASCADE in our table definition, 
    // deleting the slip will automatically delete its items.
    int result = await db.delete(
      'slips',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<int> updateSlip(SlipModel slip) async {
    final db = await dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Update the main slip
      await txn.update(
        'slips',
        slip.toMap(),
        where: 'id = ?',
        whereArgs: [slip.id],
      );

      // 2. Simplest way to update items: Delete old ones and insert new ones
      await txn.delete('slip_items', where: 'slip_id = ?', whereArgs: [slip.id]);
      for (var step in slip.slipItems) {
        await txn.insert('slip_items', {
          'slip_id': slip.id,
          'product_id': step.product!.id,
          'kg': step.kg,
          'per_kg': step.perKg,
          'row_total': step.rowTotal,
        });
      }
      return slip.id ?? 0;
    });
  }
}