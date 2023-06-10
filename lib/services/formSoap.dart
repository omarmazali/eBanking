import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../models/champ.dart';
import '../models/form.dart';

class FormSoap {
  Future<List<Forms>> fetchFormsByCreanceID(String creanceID) async {
    // Define the SOAP endpoint URL
    const url = 'https://jabak-lah-backend.onrender.com/ws/creanciers.wsdl';

    // Define the SOAP request body for Get Forms By Creance ID
    final getFormsByCreanceIDRequest = '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
              <GetFormsByCreanceIDRequest xmlns="http://www.jl_entities.com/creancierservice">
                  <id>$creanceID</id>
              </GetFormsByCreanceIDRequest>
          </soap:Body>
      </soap:Envelope>
    ''';

    try {
      // Send the Get Forms By Creance ID SOAP request
      final getFormsByCreanceIDResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/xml'},
        body: getFormsByCreanceIDRequest,
      );

      print('SOAP FORM Response: ${getFormsByCreanceIDResponse.body}');

      // Parse the Get Forms By Creance ID SOAP response
      final formsByCreanceID = _parseFormsSoapResponse(getFormsByCreanceIDResponse.body);
      return formsByCreanceID;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  List<Forms> _parseFormsSoapResponse(String response) {
    final document = xml.XmlDocument.parse(response);
    final formsElements = document.findAllElements('ns2:forms');

    return formsElements.map((formElement) {
      final id = formElement.getElement('ns2:id')?.text ?? '';
      final champsElements = formElement.findAllElements('ns2:champs');

      final champs = champsElements.map((champElement) {
        final champID = champElement.getElement('ns2:id')?.text ?? '';
        final type = champElement.getElement('ns2:type')?.text ?? '';
        final name = champElement.getElement('ns2:name')?.text ?? '';
        final label = champElement.getElement('ns2:label')?.text ?? '';
        final value = champElement.getElement('ns2:value')?.text ?? '';

        return Champ(id: champID, type: type, name: name, label: label, value: value);
      }).toList();

      return Forms(id: id, champs: champs);
    }).toList();
  }
}