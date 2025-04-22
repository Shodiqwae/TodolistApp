import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final int userId;

  Category({
    required this.id,
    required this.name,
    required this.userId,
    this.icon,
    this.color,
  });

  // Konversi dari JSON menjadi objek Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  // Mendapatkan objek IconData dari string icon
IconData getIconData() {
  // Map to convert string icon names back to IconData objects
  Map<String, IconData> iconMap = {
    'work': Icons.work,
    'person': Icons.person,
    'flight': Icons.flight,
    'computer': Icons.computer,
    'home': Icons.home,
    'shopping_cart': Icons.shopping_cart,
    'health_and_safety': Icons.health_and_safety,
    'school': Icons.school,
    'attach_money': Icons.attach_money,
    'people': Icons.people,
    'movie': Icons.movie,
    'restaurant': Icons.restaurant,
    'label': Icons.label, // Default
  };
  
  // Return the corresponding IconData or a default if not found
  return iconMap[this.icon ?? 'label'] ?? Icons.label;
}

  // Mendapatkan warna dari string color
  Color getColor() {
    // Konversi string hex color ke objek Color
    try {
      if (color != null && color!.startsWith('#')) {
        return Color(int.parse('0xFF${color!.substring(1)}'));
      }
    } catch (e) {
      print('Error parsing color: $e');
    }
    return Colors.blue; // Default color
  }
}