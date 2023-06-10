import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountInfo {
  final String id;
  final String tel;
  final String numCompte;
  final double solde;
  final String fname;
  final String lname;

  AccountInfo(this.id, this.tel, this.numCompte, this.solde, this.fname, this.lname);
}

class AcceuilService {
  static const String apiUrl = 'https://jabak-lah-backend.onrender.com/api/client';

  static Future<AccountInfo> getAccountInfoByUsername(String username) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'text/plain; charset=UTF-8'},
      body: username,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final solde = json['compteBancaire']['solde'];
      final numCompte = json['compteBancaire']['numeroCompte'];
      final fname = json['fname'];
      final lname = json['lname'];
      final id = json['id'].toString();
      final tel = json['tel'];

      return AccountInfo(id, tel, numCompte, double.parse(solde.toString()), fname, lname);
    } else {
      throw Exception('Failed to fetch solde');
    }
  }
}
