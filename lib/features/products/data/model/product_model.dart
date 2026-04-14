import 'package:calculations/features/products/domain/entities/product.dart';

class ProductModel extends Product{
  ProductModel({
    super.id, 
    required super.name, 
    required super.perkg
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      perkg: map['perkg'],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      if(id != null) 'id': id,
      'name': name,
      'perkg': perkg,
    };
  }
  ProductModel copyWith({
    int? id,
    String? name,
    int? perkg,
  }){
    return ProductModel(
      id: id ?? this.id, 
      name: name ?? this.name, 
      perkg: perkg ?? this.perkg, 
    );
  }
}