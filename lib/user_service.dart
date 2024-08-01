import 'dart:convert';
import 'package:http/http.dart'
    as http; //  HTTP package for making HTTP requests
import 'user_model.dart';

// class to handle fetching data
class ApiService {
  static const String baseUrl = 'https://dummyjson.com/users'; // URL for API

  // fetch users parameters for sorting and filtering
  Future<List<User>> fetchUsers(int limit, int skip,
      {String? sortBy, String? order, String? gender, String? country}) async {
    String url = '$baseUrl?limit=$limit&skip=$skip';
    if (sortBy != null) {
      url += '&sort=$sortBy';
    }
    if (order != null) {
      url += '&order=$order';
    }
    if (gender != null) {
      url += '&gender=$gender';
    }
    if (country != null) {
      url += '&country=$country';
    }

    final response = await http.get(Uri.parse(url)); // Send GET request

    if (response.statusCode == 200) {
      List<dynamic> body =
          jsonDecode(response.body)['users']; // Decode the JSON response
      List<User> users = body
          .map((dynamic item) => User.fromJson(item))
          .toList(); // Map JSON data
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
