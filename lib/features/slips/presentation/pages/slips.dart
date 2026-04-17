import 'package:calculations/features/slips/presentation/bloc/slip_bloc.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_state.dart';
import 'package:calculations/features/slips/presentation/widget/slipCard.dart';
import 'package:calculations/features/slips/presentation/pages/slip_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Slips extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Slips());
  const Slips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT SIDE — white box with date & time
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("10/11/25"),
                      SizedBox(height: 4),
                      Text("10:15 AM"),
                    ],
                  ),
                ),

                // RIGHT SIDE — white box with icon
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_month, size: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<SlipBloc, SlipState>(
              listenWhen: (prev, curr) =>
                  curr.isDeleteSuccess && !prev.isDeleteSuccess,
              listener: (context, state) {
                if (state.isDeleteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state.isEditSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.slips.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Slips Found",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.slips.length,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 100,
                  ),
                  itemBuilder: (context, index) {
                    final slip = state.slips[index];
                    return SlipCard(
                      slipEntity: slip,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SlipForm(),
            ),
          );
        },
        backgroundColor: Color(0xFF5B58FF),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
