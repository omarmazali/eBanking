import 'dart:convert';
import 'package:http/http.dart' as http;

class OperationInfo {
  final String type;
  final String description;
  final String date;
  final String amount;

  OperationInfo(this.type, this.description, this.date, this.amount);
}

class OperationService {
  static const String apiUrl = 'https://jabak-lah-backend.onrender.com/api/client';

  static Future<List<OperationInfo>> getOperationInfoByUsername(String username) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'text/plain; charset=UTF-8'},
      body: username,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final operationsJson = json["compteBancaire"]['operations'] as List<dynamic>;

      final List<OperationInfo> operations = operationsJson.map((operationJson) {
        final type = operationJson['type'];
        final description = operationJson['description'];
        final date = operationJson['date'].toString();
        final amount = operationJson['amount'].toString();
        return OperationInfo(type, description, date, amount);
      }).toList();

      return operations;
    } else {
      throw Exception('Failed to fetch operations');
    }
  }
}

