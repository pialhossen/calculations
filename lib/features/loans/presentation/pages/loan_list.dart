import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_bloc.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_state.dart';
import 'package:calculations/features/loans/presentation/widget/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoanList extends StatefulWidget {
  final Employee employee;
  const LoanList({super.key, required this.employee});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  int? selectedIndex;
  late TextEditingController amountController;
  late TextEditingController noteController;

  void createNewLoan() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          amountController: amountController,
          noteController: noteController,
          employee: widget.employee,
        );
      },
    );
  }

  @override
  void initState() {
    context.read<LoanBloc>().add(LoadLoansEvent(widget.employee.id!));
    amountController = TextEditingController();
    noteController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: const Text(
            "Loan Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: BlocConsumer<LoanBloc, LoanState>(
        listenWhen: (prev, curr) =>
            (curr.isDeleteSuccess && !prev.isDeleteSuccess) ||
            (curr.isEditSuccess && !prev.isEditSuccess),
        listener: (context, state) {
          String message = state.isDeleteSuccess
              ? 'Delete Successful!'
              : 'Edit Successful!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(child: __buildListContent(state)),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: createNewLoan,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Loan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          "${state.totalLoan.toString()} TK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget __buildListContent(LoanState state) {
    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (state.isLoading && state.loans.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.loans.isEmpty) {
      return const Center(
        child: Text(
          "No Loan Found",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.separated(
      reverse: true, // This makes it render from the bottom up
      padding: const EdgeInsets.all(16),
      itemCount: state.loans.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.read<LoanBloc>().add(
              LoanUpdateEvent(
                employeeId: widget.employee.id!,
                id: state.loans[index].id!,
                type: state.loans[index].type == 1 ? 0 : 1,
              ),
            );
          },
          onLongPress: () {
            // open loan edit form and edit loan
            print('Loan Long Pressed');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: state.loans[index].type == 0 ? Colors.red : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.loans[index].type == 0
                    ? Colors.red
                    : Colors.grey[200]!,
              ),
              boxShadow: state.loans[index].type == 0
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: state.loans[index].type == 0
                        ? Colors.white24
                        : Colors.blue[50],
                    child: Icon(
                      Icons.money,
                      color: state.loans[index].type == 0
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                  title: Text(
                    "Loan #${state.loans[index].id.toString()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: state.loans[index].type == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "${DateFormat('dd/MM/yy').format(state.loans[index].dateTime)} ${DateFormat('hh:mm a').format(state.loans[index].dateTime)}",
                    style: TextStyle(
                      color: state.loans[index].type == 0
                          ? Colors.white70
                          : Colors.grey[600],
                    ),
                  ),
                  trailing: Text(
                    state.loans[index].amount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: state.loans[index].type == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.loans[index].note.toString(),
                      style: TextStyle(
                        color: state.loans[index].type == 0
                            ? Colors.white
                            : Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
