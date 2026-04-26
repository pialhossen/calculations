import 'package:calculations/features/loans/presentation/widget/dialog_box.dart';
import 'package:flutter/material.dart';

class LoanList extends StatefulWidget {
  const LoanList({super.key});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  int? selectedIndex;

  // We reverse the list data once so it matches the reversed ListView
  final List<Map<String, String>> dummyLoans = List.generate(
    15,
    (index) => {
      "title": "Loan #${index + 1}",
      "date": "2026-04-${10 + index}",
      "amount": "${(index + 1) * 500} TK",
      "note": "Transaction verified for project site ${index + 101}."
    },
  ).reversed.toList(); 
  void createNewLoan(){
    showDialog(
      context: context, 
      builder: (context) {
        return DialogBox();
      }
    );
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true, // This makes it render from the bottom up
                padding: const EdgeInsets.all(16),
                itemCount: dummyLoans.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final bool isActive = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = isActive ? null : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive ? Colors.red : Colors.grey[200]!,
                        ),
                        boxShadow: isActive 
                          ? [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                          : [],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isActive ? Colors.white24 : Colors.blue[50],
                              child: Icon(
                                Icons.money,
                                color: isActive ? Colors.white : Colors.blue,
                              ),
                            ),
                            title: Text(
                              dummyLoans[index]["title"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isActive ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              dummyLoans[index]["date"]!,
                              style: TextStyle(
                                color: isActive ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                            trailing: Text(
                              dummyLoans[index]["amount"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isActive ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Note: ${dummyLoans[index]["note"]}",
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black,
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
              ),
            ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      "20000 TK",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}