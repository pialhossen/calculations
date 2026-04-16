class SlipItemEntity {
  final int? id;
  String productName;
  double kg;
  double perKg;
  double rowTotal; // Remove 'final' here

  SlipItemEntity({
    this.id,
    this.productName = '',
    this.kg = 0.0,
    this.perKg = 0.0,
    this.rowTotal = 0.0,
  });
}