import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {

  static const String key = "favorite_news";

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    return data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }
  static Future<bool> isFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    for (var item in data) {
      final decoded = jsonDecode(item);
      if (decoded["title"] == title) {
        return true;
      }
    }

    return false;
  }
  static Future<void> addFavorite(Map<String, dynamic> article) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    data.add(jsonEncode(article));

    await prefs.setStringList(key, data);
  }

  static Future<void> removeFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    data.removeWhere((element) {
      final item = jsonDecode(element);
      return item["title"] == title;
    });

    await prefs.setStringList(key, data);
  }
}