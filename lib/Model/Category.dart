import 'package:flutter/material.dart';

class Category {

  static final Map<String, IconData> _icons = {
    'Food': Icons.fastfood,
    'Transport': Icons.directions_car,
    'Shopping': Icons.shopping_cart,
    'Entertainment': Icons.movie,
    'Health': Icons.local_hospital,
    'Travel': Icons.flight,
    'Education': Icons.school,
    'Tax': Icons.attach_money,
    'Other': Icons.more_horiz,
  };

  static final defaultCategory = Category(name: 'Other');

  static final categories = [
    Category(name: 'Food'),
    Category(name: 'Transport'),
    Category(name: 'Shopping'),
    Category(name: 'Entertainment'),
    Category(name: 'Health'),
    Category(name: 'Travel'),
    Category(name: 'Education'),
    Category(name: 'Tax'),
    //Category(name: 'Other', icon: Icons.more_horiz),
  ];

  final String name;
  late IconData icon;


  Category({required this.name}) {

    if (_icons.containsKey(name)) {
      icon = _icons[name]!;
    } else {
      icon = Icons.question_mark;}
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Category && other.name == name;


}