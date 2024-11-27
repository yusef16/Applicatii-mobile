import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  CategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue[50],
              child: ClipOval(
                child: Image.asset(
                  categories[index].iconUrl,
                  width: 40, // Adjust the width according to your needs
                  height: 40, // Adjust the height according to your needs
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              categories[index].title,
              style: TextStyle(fontSize: 10), // Adjust the font size
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
