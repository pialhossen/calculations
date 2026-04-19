import 'package:calculations/core/database/database_helper.dart'; // Adjust path
import 'package:calculations/features/slips/data/datasources/slip_local_data_source.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:intl/intl.dart';

class SlipLocalDataSourceImpl implements SlipLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Future<int> createSlip(SlipModel slip) async {
    final db = await dbHelper.database;

    return await db.transaction((txn) async {
      int slipId = await txn.insert('slips', slip.toMap());
      for (var slipItem in slip.slipItems) {
        await txn.insert('slip_items', slipItem.toMap(slipId));
      }
      return slipId;
    });
  }

  @override
  Future<List<SlipModel>> getSlips(DateTime? datetime) async {
    final db = await dbHelper.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (datetime != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(datetime);

      whereClause = 'WHERE date(slips.date_created) = ?';
      whereArgs = [formattedDate];
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT slips.*, employee.name as employee_name, employee.number as employee_number
      FROM slips
      LEFT JOIN employee ON slips.employee_id = employee.id
      $whereClause
      ORDER BY slips.id DESC
    ''', whereArgs);

    List<SlipModel> slips = [];

    for (var map in maps) {
      final List<Map<String, dynamic>> itemMapsWithProduct = await db.rawQuery(
        '''
          SELECT slip_items.*, product.name as product_name, product.perkg as product_perkg
          FROM slip_items
          LEFT JOIN product ON slip_items.product_id = product.id
          WHERE slip_items.slip_id = ?
        ''',
        [map['id']],
      );

      slips.add(SlipModel.fromMap(map, itemMapsWithProduct));
    }

    return slips;
  }

  @override
  Future<SlipModel> getSlip(int id) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT 
      s.*, 
      e.name AS employee_name, 
      e.number AS employee_number
    FROM slips s
    INNER JOIN employee e ON s.employee_id = e.id
    WHERE s.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      final List<Map<String, dynamic>> itemMaps = await db.rawQuery(
        '''
      SELECT 
        si.*, 
        p.name as product_name, 
        p.perkg as product_perkg
      FROM slip_items si
      INNER JOIN product p ON si.product_id = p.id
      WHERE si.slip_id = ?
      ''',
        [id],
      );

      // Now maps.first contains 'employee_name' and 'employee_number'
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
    int result = await db.delete('slips', where: 'id = ?', whereArgs: [id]);
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
      await txn.delete(
        'slip_items',
        where: 'slip_id = ?',
        whereArgs: [slip.id],
      );
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
