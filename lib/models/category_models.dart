import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxcolor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxcolor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'Salad',
        iconPath: 'assets/icons/plate.svg',
        boxcolor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'Cake',
        iconPath: 'assets/icons/pancakes.svg',
        boxcolor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'Pie',
        iconPath: 'assets/icons/pie.svg',
        boxcolor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'Smoothies',
        iconPath: 'assets/icons/orange-snacks.svg',
        boxcolor: const Color(0xff92A3FD)));

    return categories;
  }
}
