import 'package:flutter/material.dart';

class FavoriteGrid extends StatelessWidget {
  final List<Map<String, String>> favoriteItems;

  const FavoriteGrid({super.key, required this.favoriteItems});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: ScrollController(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1, // Adjust height
      ),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        var item = favoriteItems[index];
        return Hero(
          tag: item['id']!,
          child: GestureDetector(
            onTap: () {
              // Handle navigation
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(item['imagePath']!),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(8),
              child: Text(
                item['quote']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}