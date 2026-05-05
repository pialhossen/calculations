import 'dart:math';

import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;

class Slip extends StatefulWidget {
  final List<SlipItemModel> steps;
  final String note;
  final String total;
  final Employee employee;
  final DateTime dateTime;
  Slip({
    super.key,
    required this.note,
    required this.total,
    required this.steps,
    required this.employee,
    required this.dateTime,
  });

  @override
  State<Slip> createState() => _SlipState();
}

class _SlipState extends State<Slip> {
  final GlobalKey _printKey = GlobalKey();

  Future<void> _downloadPdf() async {
    setState(() => _showFab = false);
    // Small delay to ensure FAB is hidden from screenshot
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      // 1. Capture the Widget as Image
      RenderRepaintBoundary? boundary =
          _printKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2. Prepare PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) =>
              pw.Center(child: pw.Image(pw.MemoryImage(pngBytes))),
        ),
      );
      final pdfBytes = await pdf.save();

      // 3. GET DEDICATED FOLDER (The "No-Restriction" Logic)
      String path = '';
      if (Platform.isAndroid) {
        // This refers to /storage/emulated/0/Download
        path = "/storage/emulated/0/Download/CalculationsApp";
      } else {
        // For iOS, use Documents folder
        final directory = await getApplicationDocumentsDirectory();
        path = "${directory.path}/CalculationsApp";
      }

      final dedicatedFolder = Directory(path);

      // 4. Create Folder if it doesn't exist
      if (!await dedicatedFolder.exists()) {
        await dedicatedFolder.create(recursive: true);
      }

      String formattedDate = DateFormat('dd_M_yyyy_h_mm_a').format(DateTime.now()).toLowerCase();

      // 2. Generate a random number (e.g., 7 digits)
      int randomNumber = Random().nextInt(9000000) + 1000000;

      // 3. Combine everything
      final String fileName = 'Slip_${widget.employee.name}_${formattedDate}_$randomNumber.pdf';

      final File file = File('${dedicatedFolder.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Saved to Downloads/CalculationsApp"),
            action: SnackBarAction(label: "OK", onPressed: () {}),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      setState(() => _showFab = true);
    }
  }

  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8), // adjust this
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: Offset(-10, 0),
          child: Text(
            "${DateFormat('dd/MM/yy').format(widget.dateTime)} ${widget.employee.name}", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _printKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // LEFT SIDE — white box with date & time
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM/yy').format(widget.dateTime),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('hh:mm a').format(widget.dateTime),
                              ),
                            ],
                          ),
                        ),

                        // RIGHT SIDE — white box with icon
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(widget.employee.name),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ...widget.steps.asMap().entries.map((entry) {
                          int idx = entry.key;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Text(
                                          widget
                                                      .steps[idx]
                                                      .product
                                                      .name
                                                      .length >
                                                  8
                                              ? '${widget.steps[idx].product.name.substring(0, 8)}...'
                                              : widget.steps[idx].product.name,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.arrow_forward, size: 14),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.steps[idx].perKg
                                          .floor()
                                          .toString(),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.close, size: 15),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.steps[idx].kg.toString(),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      FontAwesomeIcons.equals,
                                      size: 13,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.steps[idx].rowTotal
                                          .floor()
                                          .toString(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300], // Line color
                    thickness: 2, // The thickness of the line
                    indent: 20, // Empty space to the left of the line
                    endIndent: 20, // Empty space to the right of the line
                    height: 50, // The total space the divider occupies
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // width: 120,
                        alignment: Alignment.center,
                        // height: 30,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Total = ${widget.total}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Text(widget.note),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: _downloadPdf,
              child: Icon(Icons.download),
              tooltip: 'Download as PDF',
            )
          : null,
    );
  }
}
