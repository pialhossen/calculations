abstract class ProductEvent {}

class ProductCreateEvent extends ProductEvent{
  final String name;
  final int perkg;
  ProductCreateEvent(this.name, this.perkg);
}

class ProductUpdateEvent extends ProductEvent{
  final int id;
  final String name;
  final int perkg;
  ProductUpdateEvent(this.id, this.name, this.perkg);
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