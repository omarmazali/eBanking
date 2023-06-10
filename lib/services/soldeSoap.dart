import 'package:http/http.dart' as http;
import 'package:untitled/models/payment.dart';
import 'package:xml/xml.dart' as xml;

class SoldeService {
  Future<String> confirmerPaiement(List<String> impayes, String clientID, String smsCode) async {

    const String apiUrl = 'https://jabak-lah-backend.onrender.com/ws/creanciers.wsdl';

    final ConfirmerPaymentRequest = _buildConfimerSoapRequest(clientID, impayes, smsCode);

    try {
      final confirmerPaiementResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'text/xml'},
        body: ConfirmerPaymentRequest,
      );

      final message = _parseConfirmerPaiementSoapResponse(confirmerPaiementResponse.body);

      return message;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to confirm payment');
    }
  }


  String _buildConfimerSoapRequest(String clientID, List<String> impayes, String smsCode) {
    final impayesID = impayes.map((credential) {
      return '''<impayes>$credential</impayes>''';
    }).join('');
    return '''<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ConfirmerPayementRequest xmlns="http://www.jl_entities.com/creancierservice">$impayesID<code>$smsCode</code><clientId>$clientID</clientId></ConfirmerPayementRequest></soap:Body></soap:Envelope>''';
  }

  String _parseConfirmerPaiementSoapResponse(String response) {
    final document = xml.XmlDocument.parse(response);
    final entryElements = document.findAllElements('ns2:entry');

    for (var entryElement in entryElements) {
      final key = entryElement.getElement('ns2:key')?.text ?? '';
      final value = entryElement.getElement('ns2:value')?.text ?? '';

      if (key == 'message') {
        return value;
      }
    }
    return '';
  }
}
