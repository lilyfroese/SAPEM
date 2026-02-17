import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api.dart';
import '../core/api/api_response.dart';
import '../core/api/auth_storage.dart';

class AuthService {
  final AuthStorage storage = AuthStorage();

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String grupo,
  }) async {
    final response = await Api.client.post(
      "/users",
      {
        "username": nome,
        "email": email,
        "grupo": grupo,
        "password": senha,
      },
    );

    return response.ok;
  }

  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    final response = await Api.client.post(
      "/login",
      {
        "email": email,
        "password": senha,
      },
    );

    if (!response.ok) {
      return false;
    }

    final data = response.data;

    final token = data["token"];
    final type = data["type"] ?? 'auth_token';
    final user = data["user"];

    if (token == null || user == null) {
      return false;
    }

    await storage.saveTokens(
      token: token,
      type: type,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", user["id"]);

    return true;
  }

  Future<void> logout() async {
    await storage.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userId");
  }

  Future<Map<String, dynamic>?> getUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final type = prefs.getString("type");
    final id = prefs.getInt("userId");

    if (token == null || id == null) {
      return null;
    }

    final response = await Api.client.get(
      "/users/$id",
      headers: {
        "Authorization": "$type $token",
      },
    );

    if (!response.ok) return null;

    return response.data;
  }

  Future<bool> atualizarUsuario({
    required String nome,
    required String email,
    required String grupo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final type = prefs.getString("type");
    final id = prefs.getInt("userId");

    if (token == null || id == null) {
      return false;
    }

    final response = await Api.client.put(
      "/users/$id",
      {
        "username": nome,
        "email": email,
        "grupo": grupo,
      },
      headers: {
        "Authorization": "$type $token",
      },
    );

    return response.ok;
  }

  Future<void> criarMeta({
    required String title,
    required String category,
    required String color,
    required String icon,
    required bool notify,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final type = prefs.getString("type") ?? "auth_token";
    final id = prefs.getInt("userId");

    if (token == null || id == null) {
      throw Exception("Token ou userId não encontrado");
    }

    await Api.client.post(
      "/metas",
      {
        "title": title,
        "category": category,
        "color": color,
        "icon": icon,
        "notify": notify,
        "userId": id,
      },
      headers: {
        "Authorization": "$type $token",
      },
    );
  }
}
