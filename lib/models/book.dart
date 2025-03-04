import 'package:flutter/material.dart';

class Book {
  String title;
  Color color;
  String content;
  IconData icon;

  Book({required this.title, required this.color, this.content = "", this.icon = Icons.book});
}
