import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class Category {
  static List<Category> categories = [
    Category.withIcon(
        name: 'Comida', icon: Icons.fastfood),
    Category.withIcon(
        name: 'Transporte', icon: Icons.directions_car),
    Category.withIcon(
        name: 'Compras', icon: Icons.shopping_cart),
    Category.withIcon(
        name: 'Entretenimiento', icon: Icons.movie),
    Category.withIcon(
        name: 'Salud', icon: Icons.local_hospital),
    Category.withIcon(name: 'Viajes', icon: Icons.flight),
    Category.withIcon(
        name: 'Educación', icon: Icons.school),
    Category.withIcon(
        name: 'Pagos', icon: Icons.attach_money),
    Category.withIcon(name: 'Otros', icon: Icons.category),
  ];

  // Default category
  static Category defaultCategory = Category.withIcon(
      name: 'Otros', icon: Icons.category);

  String name;
  late IconData icon;

  Category(
      {required this.name, required int iconCode}) {
    icon = IconData(iconCode, fontFamily: 'MaterialIcons');
  }

  Category.withIcon(
      {required this.name, required this.icon});

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Category && other.name == name;
}
