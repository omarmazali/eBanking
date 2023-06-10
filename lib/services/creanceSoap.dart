import 'package:untitled/models/creance.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class CreanceSoap{

  Future<List<Creance>> fetchCreancesByCreancierID(String creancierID) async {
    // Define the SOAP endpoint URL
    const url = 'https://jabak-lah-backend.onrender.com/ws/creanciers.wsdl';

    // Define the SOAP request body for Get Creances By Creancier ID
    final getCreancesByCreancierIDRequest = '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
              <GetCreancesByCreancierIDRequest xmlns="http://www.jl_entities.com/creancierservice">
                  <id>$creancierID</id>
              </GetCreancesByCreancierIDRequest>
          </soap:Body>
      </soap:Envelope>
    ''';

    try {
      // Send the Get Creances By Creancier ID SOAP request
      final getCreancesByCreancierIDResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/xml'},
        body: getCreancesByCreancierIDRequest,
      );

      // Parse the Get Creances By Creancier ID SOAP response
      final creancesByCreancierID = _parseCreancesSoapResponse(getCreancesByCreancierIDResponse.body);
      return creancesByCreancierID;
      //setState(() {
      //  creances = creancesByCreancierID;
      //  forms.clear();
      //});
    } catch (e) {
      print('Error: $e');
      return[];
    }
  }

  List<Creance> _parseCreancesSoapResponse(String response) {
    final document = xml.XmlDocument.parse(response);
    final creancesElements = document.findAllElements('ns2:creances');

    return creancesElements.map((creanceElement) {
      final id = creanceElement.getElement('ns2:id')?.text ?? '';
      final code = creanceElement.getElement('ns2:code')?.text ?? '';
      final name = creanceElement.getElement('ns2:name')?.text ?? '';

      return Creance(id: id, code: code, name: name);
    }).toList();
  }
}