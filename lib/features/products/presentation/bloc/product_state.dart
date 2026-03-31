import 'package:calculations/features/products/domain/entities/product.dart';

enum ProductActiveStatus { none, deleted, updated, created }

class ProductState {
  final List<Product> products;
  final Product? selectedProduct;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleteSuccess;
  final bool isEditSuccess;
  final ProductActiveStatus lastActive;

  ProductState({
    this.products = const [],
    this.selectedProduct,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleteSuccess = false,
    this.isEditSuccess = false,
    this.lastActive = ProductActiveStatus.none,
  });
  ProductState copyWith({
    List<Product>? products,
    Product? selectedProduct,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleteSuccess,
  }){
    return ProductState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess, 
    );
  }
}
