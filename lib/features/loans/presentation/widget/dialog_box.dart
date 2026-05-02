import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/domain/entities/loan.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_bloc.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController noteController;
  final Employee employee;
  final Loan? loan;
  final GlobalKey<FormState> formkey;
  const DialogBox({
    super.key,
    required this.amountController,
    required this.noteController,
    required this.employee,
    required this.formkey,
    this.loan,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    void saveLoan() {
      if (widget.formkey.currentState!.validate()) {
        if (widget.loan == null) {
          context.read<LoanBloc>().add(
            LoanCreateEvent(
              amount: double.tryParse(widget.amountController.text.trim()) ?? 0,
              employeeId: widget.employee.id!,
              type: 1,
              note: widget.noteController.text,
            ),
          );
          widget.amountController.text = "";
          widget.noteController.text = "";
        } else {
          context.read<LoanBloc>().add(
            LoanUpdateEvent(
              id: widget.loan!.id!,
              amount: double.tryParse(widget.amountController.text.trim()) ?? 0,
              employeeId: widget.employee.id!,
              type: 1,
              note: widget.noteController.text,
            ),
          );
          widget.amountController.text = "";
          widget.noteController.text = "";
        }
        Navigator.pop(context);
      }
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      // Removes the rounded corners from the dialog
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: SingleChildScrollView(
        child: Form(
          key: widget.formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Constrains dialog to content size
            children: [
              Text(
                widget.loan == null ? "Add New Loan" : "Update Loan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Loan Amount",
                  hintText: "e.g. 500",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                controller: widget.amountController,
                validator: (value) {
                  final parsedValue = double.tryParse(value ?? '0');
                  if (value!.isEmpty) {
                    return "Loan amount missing";
                  }
                  if (parsedValue == null) {
                    return "Amount Cannot be null";
                  }
                  if (parsedValue < 1) {
                    return "Amount Cannot be less then";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Note Field (HTML Textarea Style)
              TextFormField(
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  labelText: "Note",
                  hintText: "Enter details here...",
                  alignLabelWithHint:
                      true, // Moves label to top-left of textarea
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                controller: widget.noteController,
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Save Button
                  MaterialButton(
                    onPressed: saveLoan,
                    color: Colors.blue,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      widget.loan == null ? 'Save' : 'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
