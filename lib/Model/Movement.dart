import 'Category.dart';

class Movement {
  final String description;
  final double amount;
  final DateTime date;
  final Category category;
  final String type;

  Movement({required this.description, required this.amount, required this.date, required this.category, required this.type});
}