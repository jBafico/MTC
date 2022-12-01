import 'package:flutter/material.dart';

class Category {

  static final Map<String, IconData> _icons = {
    'Comida': Icons.fastfood,
    'Transporte': Icons.directions_car,
    'Compras': Icons.shopping_cart,
    'Entretenimiento': Icons.movie,
    'Salud': Icons.local_hospital,
    'Viajes': Icons.flight,
    'Educación': Icons.school,
    'Pagos': Icons.attach_money,
    'Nueva Categoría': Icons.add,
  };

  static final defaultCategory = Category(name: 'Other');

  static List<Category> categories = [
    Category(name: 'Comida'),
    Category(name: 'Transporte'),
    Category(name: 'Compras'),
    Category(name: 'Entretenimiento'),
    Category(name: 'Salud'),
    Category(name: 'Viajes'),
    Category(name: 'Educación'),
    Category(name: 'Pagos'),
    // Category(name: 'Nueva Categoría'),
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