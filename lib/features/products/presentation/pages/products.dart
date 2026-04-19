import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:calculations/features/products/presentation/widget/product_card.dart';
import 'package:calculations/features/products/presentation/pages/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Products extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Products());

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
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(width: 10), // spacing
                Expanded(
                  child: TextField(
                    onChanged: (value) {
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
            child: BlocConsumer<ProductBloc, ProductState>(
              listenWhen: (previous, current) => current.isDeleteSuccess && !previous.isDeleteSuccess,
              listener: (context, state) {
                if(state.isDeleteSuccess){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }else if(state.isEditSuccess){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Center(
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state.isLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.products.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Products Found",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.products.length,
                  padding: EdgeInsets.only(top: 20, bottom: 70),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Productcard(product: product);
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
            MaterialPageRoute(
              builder: (BuildContext context) => const ProductForm(),
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
