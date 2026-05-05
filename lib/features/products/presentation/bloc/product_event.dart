import 'dart:io';

abstract class ProductEvent {}

class ProductCreateEvent extends ProductEvent{
  final String name;
  final int perkg;
  final File? image;
  ProductCreateEvent({
    required this.name, 
    required this.perkg,
    this.image
  });
}

class ProductUpdateEvent extends ProductEvent{
  final int id;
  final String name;
  final int perkg;
  final File? image;
  ProductUpdateEvent({ 
    required this.id, 
    required this.name, 
    required this.perkg,
    required this.image
  });
}

class SingleProductEvent extends ProductEvent{
  final int id;
  SingleProductEvent(this.id);
}
class ProductDeleteEvent extends ProductEvent{
  final int id;
  ProductDeleteEvent(this.id);
}
class LoadProductsEvent extends ProductEvent{
  final String? q;
  LoadProductsEvent({this.q});
}