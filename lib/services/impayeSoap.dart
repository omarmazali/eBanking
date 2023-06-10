import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../models/impaye.dart';
import '../models/credential.dart';

class ImpayeSoap {
  Future<List<Impaye?>> fetchImpayesByCreanceID(String creanceID, List<Credential> credentials) async {
    // Define the SOAP endpoint URL
    const url = 'https://jabak-lah-backend.onrender.com/ws/creanciers.wsdl';

    // Build the SOAP request body for Get Impayes By Creance ID
    final getImpayesByCreanceIDRequest = _buildImpayesSoapRequest(creanceID, credentials);

    try {
      // Send the Get Impayes By Creance ID SOAP request
      final getImpayesByCreanceIDResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/xml'},
        body: getImpayesByCreanceIDRequest,
      );

      // Parse the Get Impayes By Creance ID SOAP response
      final impayesByCreanceID = _parseImpayesSoapResponse(getImpayesByCreanceIDResponse.body);

      print('Parsed Impayes: $impayesByCreanceID');

      return impayesByCreanceID;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  String _buildImpayesSoapRequest(String creanceID, List<Credential> credentials) {
    final credentialElements = credentials.map((credential) {
      return '''
        <credential>
          <credentialName>${credential.name}</credentialName>
          <credentialValue>${credential.value}</credentialValue>
        </credential>
      ''';
    }).join('');

    return '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
              <GetImpayesByCreanceIDRequest xmlns="http://www.jl_entities.com/creancierservice">
                  <creanceId>$creanceID</creanceId>
                  <credentials>
                      $credentialElements
                  </credentials>
              </GetImpayesByCreanceIDRequest>
          </soap:Body>
      </soap:Envelope>
    ''';
  }

  List<Impaye?> _parseImpayesSoapResponse(String response) {
    final document = xml.XmlDocument.parse(response);
    final impayesElements = document.findAllElements('ns2:impayes');

    return impayesElements.map((impayeElement) {
      final id = impayeElement.getElement('ns2:id')?.text ?? '';
      final name = impayeElement.getElement('ns2:name')?.text ?? '';
      final price = impayeElement.getElement('ns2:price')?.text ?? '';
      final isPaid = impayeElement.getElement('ns2:isPaid')?.text ?? '';
      final date = impayeElement.getElement('ns2:date')?.text ?? '';

      if (isPaid.toLowerCase() == 'false') {
        return Impaye(id: id, name: name, price: price, isPaid: isPaid, date: date);
      }
      return null;


    }).where((impaye) => impaye != null).toList();
  }
}
