import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  static Future<List<Meal>> getCategory() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List list = data['meals'];

      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}