import 'package:calculations/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Setting extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Setting());
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> exportDatabase() async {
      final db = await DatabaseHelper.instance.database;

      // 1. Fetch data from all tables
      List<Map<String, dynamic>> slips = await db.query('slips');
      List<Map<String, dynamic>> slipItems = await db.query('slip_items');
      List<Map<String, dynamic>> employees = await db.query('employee');
      List<Map<String, dynamic>> products = await db.query('product');

      // 2. Wrap into a single Map
      Map<String, dynamic> backup = {
        'slips': slips,
        'slip_items': slipItems,
        'employees': employees,
        'products': products,
        'exported_at': DateTime.now().toIso8601String(),
      };

      // 3. Convert to String and Save
      String jsonString = jsonEncode(backup);
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );

      await file.writeAsString(jsonString);

      // 4. Share the file (Opens the phone's share sheet so you can save to Drive/WhatsApp/Email)
      await Share.shareXFiles([XFile(file.path)], text: 'My Database Backup');
    }

    Future<void> importDatabase() async {
      // Use this syntax:
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        Map<String, dynamic> backup = jsonDecode(content);

        final db = await DatabaseHelper.instance.database;

        // Use a transaction for safety
        await db.transaction((txn) async {
          // 1. Clear existing data
          await txn.delete('slips');
          await txn.delete('slip_items');
          await txn.delete('employee');
          await txn.delete('product');

          // 2. Re-insert data
          for (var row in backup['employees'])
            await txn.insert('employee', row);
          for (var row in backup['products']) await txn.insert('product', row);
          for (var row in backup['slips']) await txn.insert('slips', row);
          for (var row in backup['slip_items'])
            await txn.insert('slip_items', row);
        });

        print("Import successful!");
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/upload.png"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Export',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text('as json'),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: 15,
                    right: 15,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                  child: GestureDetector(
                    onTap: exportDatabase,
                    child: Row(
                      children: [
                        Text(
                          'Export',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/download.png"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Import',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text('From json'),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: 15,
                    right: 15,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                  child: GestureDetector(
                    onTap: importDatabase,
                    child: Row(
                      children: [
                        Text(
                          'Import',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
