import 'package:flutter/material.dart';

Widget buildSearchBar() {
  return TextField(
    decoration: InputDecoration(
      hintText: 'Search doctors...',
      prefixIcon: Icon(Icons.search),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
