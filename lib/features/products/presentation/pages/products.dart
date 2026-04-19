import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart'; // Ensure events are imported
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:calculations/features/products/presentation/widget/product_card.dart';
import 'package:calculations/features/products/presentation/pages/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Products extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Products());

  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      // 1. BlocConsumer moved to the top to sync search bar and list
      body: BlocConsumer<ProductBloc, ProductState>(
        listenWhen: (prev, curr) =>
            (curr.isDeleteSuccess && !prev.isDeleteSuccess) ||
            (curr.isEditSuccess && !prev.isEditSuccess),
        listener: (context, state) {
          if (state.isDeleteSuccess || state.isEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.isDeleteSuccess
                    ? 'Delete Successful!'
                    : 'Edit Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if(state.q != null && state.q != ""){
            searchController.text = state.q ?? "";
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          // 2. Dispatch Search Event to Product Bloc
                          context.read<ProductBloc>().add(LoadProductsEvent(q: value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Search products...",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product List
              Expanded(
                child: _buildProductList(state),
              ),
            ],
          );
        },
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
        backgroundColor: const Color(0xFF5B58FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProductList(ProductState state) {
    if (state.errorMessage != null) {
      return Center(
        child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
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
      padding: const EdgeInsets.only(top: 5, bottom: 40, left: 8, right: 8),
      itemBuilder: (context, index) {
        final product = state.products[index];
        // Ensure the widget name matches your project (Productcard or ProductCard)
        return Productcard(product: product);
      },
    );
  }
}