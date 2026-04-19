import 'package:calculations/features/products/domain/use_cases/create_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_all_products_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_single_product_model_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }) : super(ProductState()){
    on<ProductCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final newProduct = await createProductUseCase.execute(event.name, event.perkg);
        emit(state.copyWith(isLoading: false, products: [newProduct, ...state.products]));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<ProductUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final updatedProduct = await updateProductUseCase.execute(event.id, event.name, event.perkg);
        final updateProductList = state.products.map((product) => product.id == event.id? updatedProduct: product).toList();
        emit(state.copyWith(isLoading: false, products: updateProductList));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<SingleProductEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, selectedProduct: null));
      // try {
        final product = await getSingleProductModelUseCase.execute(event.id);
        emit(state.copyWith(isLoading: false, selectedProduct: product));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<ProductDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        await deleteProductUseCase.execute(event.id);
        final products = await getAllProductUseCase.execute();
        emit(state.copyWith(isLoading: false, products: products));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<LoadProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final products = await getAllProductUseCase.execute();
        emit(state.copyWith(isLoading: false, products: products));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
  }
}