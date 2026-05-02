import 'dart:io';

import 'package:calculations/core/utils/pick_image.dart';
import 'package:calculations/core/widgets/input.dart';
import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductForm extends StatefulWidget {
  final int? id;
  static MaterialPageRoute route(ProductBloc bloc) => MaterialPageRoute(
    builder: (context) =>
        BlocProvider.value(value: bloc, child: const ProductForm()),
  );

  const ProductForm({super.key, this.id});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController perKgController;


  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    perKgController = TextEditingController();
    if (widget.id != null) {
      context.read<ProductBloc>().add(SingleProductEvent(widget.id!));
      nameController.text = "";
      perKgController.text = "";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    perKgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void createProduct() {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
        context.read<ProductBloc>().add(
          ProductCreateEvent(
            nameController.text,
            double.tryParse(perKgController.text)?.floor() ?? 0,
          ),
        );
      }
    }

    void updateProduct() {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
        context.read<ProductBloc>().add(
          ProductUpdateEvent(
            widget.id!,
            nameController.text,
            double.tryParse(perKgController.text)?.floor() ?? 0,
          ),
        );
      }
    }

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
            widget.id == null? "Add New Product": "Edit Product",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listenWhen: (previous, current) => previous.selectedProduct != current.selectedProduct,
        listener: (context, state) {
          if (state.selectedProduct != null) {
            nameController.text = state.selectedProduct!.name;
            perKgController.text = state.selectedProduct!.perkg.toString();
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: const  CircularProgressIndicator());
          }
          return Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: image == null
                        ? DottedBorder(
                            color: Colors.grey,
                            strokeWidth: 2,
                            dashPattern: const [10, 2],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 40),
                                  SizedBox(height: 15),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.file(image!, fit: BoxFit.cover),
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  Input(
                    label: 'NAME',
                    placeholder: 'Enter Product Name',
                    controller: nameController,
                  ),
                  SizedBox(height: 20),
                  Input(
                    label: 'PER KG',
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    placeholder: 'Enter Per KG Value',
                    controller: perKgController,
                  ),
                  GestureDetector(
                    onTap: widget.id == null ? createProduct : updateProduct,
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
                        widget.id == null? "ADD": "UPDATE",
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
          );
        },
      ),
    );
  }
}
