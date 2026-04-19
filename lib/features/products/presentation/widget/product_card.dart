import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/products/presentation/pages/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Productcard extends StatelessWidget {
  final Product product;
  const Productcard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    void deleteProduct() {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              "Are you sure you want to delete this product?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Text('Cancel')
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                    ProductDeleteEvent(product.id!)
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "DELETE",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch, // make children full height
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: AssetImage("assets/images/products.png"))
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                        Text("${product.perkg.toString()} Tk KG")
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductForm(id: product.id)));
                        },
                        child: Icon(
                          Icons.edit,
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: deleteProduct,
                        child: Icon(
                          Icons.delete,
                          size: 25,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}