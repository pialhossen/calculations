import 'package:calculations/features/slips/presentation/widget/slipCard.dart';
import 'package:calculations/features/slips/presentation/pages/slip_form.dart';
import 'package:flutter/material.dart';

class Slips extends StatelessWidget {
  static MaterialPageRoute route() => MaterialPageRoute(builder: (context) => const Slips());
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
            child: ListView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              children: const [
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
                SlipCard(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => NewSlipForm(),
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
