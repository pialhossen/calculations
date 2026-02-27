import 'package:calculations/widgets/productCard.dart';
import 'package:calculations/pages/forms/ProductForm.dart';
import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  const Products({super.key});

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
                Productcard(name: "plastic", phoneNumber: "32 tk per kg",),
                Productcard(name: "Iron", phoneNumber: "32 tk per kg",),
                Productcard(name: "Silver", phoneNumber: "32 tk per kg",),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ProductForm(),
            )
          );
        },
        backgroundColor: Color(0xFF5B58FF),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}