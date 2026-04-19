import 'package:calculations/features/slips/presentation/bloc/slip_bloc.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_event.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_state.dart';
import 'package:calculations/features/slips/presentation/widget/slipCard.dart';
import 'package:calculations/features/slips/presentation/pages/slip_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Slips extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Slips());
  const Slips({super.key});

  @override
  State<Slips> createState() => _SlipsState();
}

class _SlipsState extends State<Slips> {
  // We handle the date selection via the Bloc state to ensure persistence
  Future<void> _selectDate(BuildContext context, DateTime currentSelection) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentSelection,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Dispatch event to Bloc - the Bloc manages the state survival
      context.read<SlipBloc>().add(LoadSlipEvent(dateTime: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<SlipBloc, SlipState>(
        // Listen for successes to show snackbars
        listenWhen: (prev, curr) =>
            (curr.isDeleteSuccess && !prev.isDeleteSuccess) ||
            (curr.isEditSuccess && !prev.isEditSuccess),
        listener: (context, state) {
          String message = state.isDeleteSuccess ? 'Delete Successful!' : 'Edit Successful!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT SIDE — Synced with Bloc State
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd/MM/yy').format(state.selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a').format(state.selectedDate),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    // RIGHT SIDE — Calendar Trigger
                    GestureDetector(
                      onTap: () => _selectDate(context, state.selectedDate),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calendar_month, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : state.slips.isEmpty
                    ? const Center(
                        child: Text(
                          "No Slips Found",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.slips.length,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 100,
                        ),
                        itemBuilder: (context, index) {
                          final slip = state.slips[index];
                          return SlipCard(slipEntity: slip);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SlipForm(),
            ),
          );
        },
        backgroundColor: const Color(0xFF5B58FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}