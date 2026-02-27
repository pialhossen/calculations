import 'package:calculations/widgets/employeeCard.dart';
import 'package:calculations/pages/forms/EmployeeForm.dart';
import 'package:flutter/material.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(width: 10), // spacing
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      print("User Typed: $value");
                    },
                    decoration: InputDecoration(
                      hintText: "Search here",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 70),
              children: [
                EmployeeCard(name: "Sumon", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Rofik", phoneNumber: "01316235467",),
                EmployeeCard(name: "Alamin", phoneNumber: "01316235467",),
                EmployeeCard(name: "Alamin", phoneNumber: "01316235467",),
                EmployeeCard(name: "Alamin", phoneNumber: "01316235467",),
                EmployeeCard(name: "Alamin", phoneNumber: "01316235467",),
                EmployeeCard(name: "Alamin", phoneNumber: "01316235467",),
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
              builder: (BuildContext context) => const EmployeesForm(),
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
