

import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_bloc.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController noteController;
  final Employee employee;
  const DialogBox({
    super.key, 
    required this.amountController, 
    required this.noteController,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    void createNewLoan() {
      context.read<LoanBloc>().add(
        LoanCreateEvent(
          amount: double.tryParse(amountController.text.trim()) ?? 0,
          employeeId: employee.id!,
          type: 1,
          note: noteController.text
        )
      );
      Navigator.pop(context);
    }
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
              controller: amountController,
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
              controller: noteController,
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
                  onPressed: createNewLoan,
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