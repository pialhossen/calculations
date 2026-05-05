import 'package:calculations/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Setting extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Setting());
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> exportRawDatabaseFile() async {
      // Get the path to the actual SQLite file
      final dbPath = join(await getDatabasesPath(), 'database.db');
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        // Share the actual binary file
        await Share.shareXFiles([
          XFile(dbPath),
        ], text: 'SQLite Database Backup');
      }
    }

    Future<void> importRawDatabaseFile() async {
      FilePickerResult? result = await FilePicker.pickFiles();

      if (result != null && result.files.single.path != null) {
        final newDbFile = File(result.files.single.path!);
        final dbPath = join(await getDatabasesPath(), 'database.db');

        // 1. Close current connection
        final db = await DatabaseHelper.instance.database;
        await db.close();

        // 2. Overwrite the file
        await newDbFile.copy(dbPath);

        // 3. Show the Mandatory Restart Dialog
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false, // User MUST click the button
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Import Successful"),
                content: const Text(
                  "The database has been restored. The app must restart to load the new data correctly.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // This terminates the app process
                      exit(0);
                    },
                    child: const Text("CLOSE APP"),
                  ),
                ],
              );
            },
          );
        }
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
                    onTap: exportRawDatabaseFile,
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
                    onTap: importRawDatabaseFile,
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
