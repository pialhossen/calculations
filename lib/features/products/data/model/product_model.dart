import 'package:calculations/features/products/domain/entities/product.dart';

class ProductModel extends Product{
  ProductModel({
    super.id, 
    super.image,
    required super.name, 
    required super.perkg,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      perkg: map['perkg'],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      if(id != null) 'id': id,
      'image': image,
      'name': name,
      'perkg': perkg,
    };
  }
  ProductModel copyWith({
    int? id,
    String? name,
    int? perkg,
    String? image,
  }){
    return ProductModel(
      id: id ?? this.id, 
      image: image ?? this.image,
      name: name ?? this.name, 
      perkg: perkg ?? this.perkg, 
    );
  }
}