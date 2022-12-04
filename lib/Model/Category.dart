import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class Category {
  static List<Category> categories = [
    Category.withIcon(
        name: 'Comida', icon: Icons.fastfood, color: kPrimaryColor),
    Category.withIcon(
        name: 'Transporte', icon: Icons.directions_car, color: kPrimaryColor),
    Category.withIcon(
        name: 'Compras', icon: Icons.shopping_cart, color: kPrimaryColor),
    Category.withIcon(
        name: 'Entretenimiento', icon: Icons.movie, color: kPrimaryColor),
    Category.withIcon(
        name: 'Salud', icon: Icons.local_hospital, color: kPrimaryColor),
    Category.withIcon(name: 'Viajes', icon: Icons.flight, color: kPrimaryColor),
    Category.withIcon(
        name: 'Educación', icon: Icons.school, color: kPrimaryColor),
    Category.withIcon(
        name: 'Pagos', icon: Icons.attach_money, color: kPrimaryColor),
    Category.withIcon(name: 'Otros', icon: Icons.category, color: kPrimaryColor),
  ];

  // Default category
  static Category defaultCategory = Category.withIcon(
      name: 'Otros', icon: Icons.category, color: kPrimaryColor);

  String name;
  late IconData icon;
  late Color color;

  Category(
      {required this.name, required int iconCode, required int colorValue}) {
    icon = IconData(iconCode, fontFamily: 'MaterialIcons');
    color = Color(colorValue);
  }

  Category.withIcon(
      {required this.name, required this.icon, required this.color});

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Category && other.name == name;
}
