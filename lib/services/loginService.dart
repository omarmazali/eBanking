import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {

  Future<String?> authenticate(String username, String password) async {
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8090/client/auth/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['token'];
    } else if (response.statusCode == 401) {
      throw Exception('Client not found'); // Handle the specific error case
    } else {
      return null;
    }
  }
}

