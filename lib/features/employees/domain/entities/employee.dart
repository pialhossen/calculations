class Employee {
  final int? id;
  final String name;
  final String number;
  final double loanAmount;
  final String? image;

  Employee({
    this.id, 
    required this.name, 
    required this.number, 
    required this.loanAmount,
    this.image
  });
}