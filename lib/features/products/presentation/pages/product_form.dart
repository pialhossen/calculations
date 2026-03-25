import 'package:calculations/core/widgets/input.dart';
import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(builder: (context) => const ProductForm());
  
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final perKgController = TextEditingController();

  @override
  void dispose() { 
    nameController.dispose();
    perKgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8), // adjust this
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: Offset(-10, 0),
          child: Text(
            "Add New Product", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Input(
                label: 'NAME',
                placeholder: 'Enter Product Name',
                controller: nameController,
              ),
              SizedBox(height: 20),
              Input(
                label: 'PER KG',
                placeholder: 'Enter Per KG Value',
                controller: perKgController,
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
          
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "ADD",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
