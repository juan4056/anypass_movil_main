import 'dart:convert';

import 'package:anypass_movil_main/provider/dio_client.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

const signupUrl = 'https://anypass-backend.herokuapp.com/signup';
const signinUrl = 'https://anypass-backend.herokuapp.com/signin';
const applicationsUrl = 'https://anypass-backend.herokuapp.com/applications';
const decryptUrl = 'https://anypass-backend.herokuapp.com/decrypt';
const encryptUrl = 'https://anypass-backend.herokuapp.com/encrypt';

class Provider {
  Provider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();
  final _dioClient = DioHandler.instance();
  final http.Client _httpClient;

  Future<String> login(String email, String password, String colorCode) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(signinUrl),
        body: jsonEncode({
          'email': email,
          'masterPassword': password,
          'colorCode': colorCode,
        }),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
      );
      final box = GetStorage();
      if (response.statusCode == 200) {
        final accessToken =
            (jsonDecode(response.body) as Map<String, dynamic>)['token'];
        await box.write('jwtToken', accessToken);
        return 'success';
      }
      return (jsonDecode(response.body) as Map<String, dynamic>)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> register(
      String email, String password, String colorCode) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(signupUrl),
        body: jsonEncode({
          'email': email,
          'masterPassword': password,
          'colorCode': colorCode,
        }),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return 'success';
      }
      return (jsonDecode(response.body) as Map<String, dynamic>)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<List<String>> getApplications() async {
    try {
      final box = GetStorage();
      final token = box.read<String>('jwtToken');
      final response = await _httpClient.get(
        Uri.parse(applicationsUrl),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      print(response);
      if (response.statusCode == 200) {
        final body = (jsonDecode(response.body) as Map<String, dynamic>);
        return (body['applicationNames'] as List<dynamic>)
            .map<String>((e) => e as String)
            .toList();
      }
      return List<String>.empty();
    } catch (e) {
      print(e);
      return List<String>.empty();
    }
  }

  Future<String> decrypt(String app, int index) async {
    try {
      final box = GetStorage();
      final token = box.read<String>('jwtToken');
      final response = await _httpClient.post(
        Uri.parse(decryptUrl),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'index': index,
          'application': app,
        }),
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<String> encrypt(String app, String name, String password) async {
    try {
      final box = GetStorage();
      final token = box.read<String>('jwtToken');
      final response = await _httpClient.post(
        Uri.parse(encryptUrl),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'application': app,
          'username': name,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        return 'success';
      }
      return (jsonDecode(response.body) as Map<String, dynamic>)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
