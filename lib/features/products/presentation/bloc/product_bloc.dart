import 'dart:io';

import 'package:calculations/features/products/domain/use_cases/create_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_all_products_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_single_product_model_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final GetAllProductsUseCase getAllProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final GetSingleProductModelUseCase getSingleProductModelUseCase;
  ProductBloc({
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.getAllProductUseCase,
    required this.deleteProductUseCase,
    required this.getSingleProductModelUseCase,
  }) : super(ProductState()) {
    on<ProductCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      String? imagePath;

      if (event.image != null) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;

        final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(event.image!.path)}";
        final String localPath = '$path/$fileName';

        final File localImage = await File(event.image!.path).copy(localPath);

        imagePath = localImage.path;
      }
      final newProduct = await createProductUseCase.execute(
        name: event.name,
        perkg: event.perkg,
        image: imagePath,
      );
      emit(
        state.copyWith(
          isLoading: false,
          products: [newProduct, ...state.products],
        ),
      );
    });
    on<ProductUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final oldProduct = state.products.firstWhere((e) => e.id == event.id);
      String? imagePath = oldProduct.image;

      if (event.image != null) {
        if (oldProduct.image != null) {
          final oldFile = File(oldProduct.image!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;
        final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(event.image!.path)}";
        final String localPath = '$path/$fileName';

        final File localImage = await File(event.image!.path).copy(localPath);
        imagePath = localImage.path;
      }
      final updatedProduct = await updateProductUseCase.execute(
        id: event.id,
        name: event.name,
        perkg: event.perkg,
        image: imagePath,
      );
      final updateProductList = state.products
          .map((product) => product.id == event.id ? updatedProduct : product)
          .toList();
      emit(state.copyWith(isLoading: false, products: updateProductList));
    });
    on<SingleProductEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, selectedProduct: null));
      final product = await getSingleProductModelUseCase.execute(event.id);
      emit(state.copyWith(isLoading: false, selectedProduct: product));
    });
    on<ProductDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final productToDelete = state.products.firstWhere(
          (e) => e.id == event.id,
        );

        if (productToDelete.image != null) {
          final file = File(productToDelete.image!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (e) {
        debugPrint("Error deleting image file: $e");
      }
      await deleteProductUseCase.execute(event.id);
      final products = await getAllProductUseCase.execute(null);
      emit(state.copyWith(isLoading: false, products: products));
    });
    on<LoadProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final products = await getAllProductUseCase.execute(event.q);
      emit(state.copyWith(isLoading: false, products: products));
    });
  }
}