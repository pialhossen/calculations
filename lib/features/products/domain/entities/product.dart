class Product {
  final int? id;
  final String name;
  final String? image;
  final int perkg;

  Product({
    required this.id, 
    required this.name, 
    required this.perkg,
    this.image,
  });
}
