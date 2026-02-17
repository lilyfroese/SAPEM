import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'api_response.dart';
import 'auth_storage.dart';

class HttpClient {
  final String baseUrl;
  final AuthStorage authStorage = AuthStorage();

  HttpClient(this.baseUrl);

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    return _send(
      'GET',
      path,
      extraHeaders: headers,
    );
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    return _send(
      'POST',
      path,
      body: body,
      extraHeaders: headers,
    );
  }

  Future<ApiResponse> put(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    return _send(
      'PUT',
      path,
      body: body,
      extraHeaders: headers,
    );
  }

  Future<ApiResponse> delete(String path, {Map<String, String>? headers}) async {
    return _send(
      'DELETE',
      path,
      extraHeaders: headers,
    );
  }

  Future<ApiResponse> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? extraHeaders,
  }) async {
    final token = await authStorage.getToken();
    final type = await authStorage.getType() ?? 'auth_token';
    print('TOKEN RAW => "$token"');
    print('TOKEN LENGTH => ${token?.length}');


    final uri = Uri.parse('$baseUrl$path');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': '$type $token',
      if (extraHeaders != null) ...extraHeaders,
    };

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Método HTTP inválido');
      }

      if (kDebugMode) {
        print('>>> ${method} ${uri}');
        print('HEADERS: $headers');
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        error: e.toString(),
      );
    }
  }
}
