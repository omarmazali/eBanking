import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../models/creancier.dart';

class CreancierSoap {
  Future<List<Creancier>> fetchCreanciers() async {
    const url = 'https://jabak-lah-backend.onrender.com/ws/creanciers.wsdl';
    final getAllCreanciersRequest = '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
              <GetAllCreanciersRequest xmlns="http://www.jl_entities.com/creancierservice">
              </GetAllCreanciersRequest>
          </soap:Body>
      </soap:Envelope>
    ''';

    try {
      final getAllCreanciersResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/xml'},
        body: getAllCreanciersRequest,
      );

      final creanciers = _parseCreanciersSoapResponse(getAllCreanciersResponse.body);
      return creanciers;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  List<Creancier> _parseCreanciersSoapResponse(String response) {
    final document = xml.XmlDocument.parse(response);
    final creanciersElements = document.findAllElements('ns2:creanciers');

    return creanciersElements.map((creancierElement) {
      final id = creancierElement.getElement('ns2:id')?.text ?? '';
      final code = creancierElement.getElement('ns2:code')?.text ?? '';
      final name = creancierElement.getElement('ns2:name')?.text ?? '';
      final logoUrl = creancierElement.getElement('ns2:logoUrl')?.text ?? '';

      return Creancier(id: id, code: code, name: name, logoUrl: logoUrl);
    }).toList();
  }
}
