import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      // Removes the rounded corners from the dialog
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Constrains dialog to content size
          children: [
            const Text(
              "Add New Loan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            
            // Amount Field
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Loan Amount",
                hintText: "e.g. 5000",
                border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Note Field (HTML Textarea Style)
            TextField(
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                labelText: "Note",
                hintText: "Enter details here...",
                alignLabelWithHint: true, // Moves label to top-left of textarea
                border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel Button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[600],
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                
                // Save Button
                MaterialButton(
                  onPressed: () {
                    // Handle save logic
                    Navigator.pop(context);
                  },
                  color: Colors.blue,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}