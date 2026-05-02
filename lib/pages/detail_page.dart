import 'package:flutter/material.dart';
import '../models/category.dart';

class DetailPage extends StatelessWidget {
  final Meal meal;

  const DetailPage({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.strMeal),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            meal.strMealThumb,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) =>
            const Icon(Icons.broken_image, size: 100),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  meal.strMeal,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),


                Row(
                  children: [
                    const Icon(Icons.perm_identity, color: Colors.redAccent),
                    const SizedBox(width: 6),
                    Text("${meal.idMeal}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.public, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text("${meal.strArea} - ${meal.strCountry}"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}